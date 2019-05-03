Function Get-FileName($initialDirectory){
    
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog #Crea el objeto ventana
    $OpenFileDialog.initialDirectory = $initialDirectory #parametro de la ubicacion al abrir la ventana
    #$openfiledialog.InitialDirectory = [System.IO.Directory]::GetCurrentDirectory() #abrir ventana en el path de ejecuccion del script
    $OpenFileDialog.Title = "Selecciona tu archivo"      #Titulo de la ventana
    $openFileDialog.filter = "PST (*.pst)| *.pst" #filtro de archivos posibles para seleccionar
    $OpenFileDialog.ShowDialog() | Out-Null  #Muestra la ventana al usuario y espera selección
    Set-Variable -Name file -Scope Global -Value $OpenFileDialog.FileName #variable almacen de ruta absoluta al archivo

    
   #Si la variable que contiene la ruta esta vacia mostrar error, sino mostrar ruta del archivo.
    if ([string]::IsNullOrEmpty($file)){
         #Write-Host "No se ha seleccionado ningun archivo PST!" -ForegroundColor Red
         Set-Variable -Name file -Scope Global -Value $False
         return $false
}
    else{
         Write-Host "El archivo seleccionado es:" -ForegroundColor Green $file
         return $true
    }
}

Function get-another(){
  #Funcion que pregunta mediante GUI si se quiere importar otro archivo PST , devuelve TRUE si se responde SI , FALSE si se responde NO
  $a = new-object -comobject wscript.shell
  $intAnswer = $a.popup("¿Quieres seleccionar otro PST?",0,"Otro?",32+4)
  If ($intAnswer -eq 6) {
    return $true
} 
  else {
    Set-Variable -Name fin -Scope Global -Value $true  #establecer FALSE para salir del while y terminar la ejecuccion
}
}

Function get-pst(){
    #Cierra Outlook y obtiene las rutas de los archivos PST
    Get-Process *Outlook* | % { $_.CloseMainWindow()} | Out-Null 
    try{
    $outlook = new-object -ComObject Outlook.Application -ErrorAction Continue
    }
    catch {
        Write-Host $_.Excepction.Message -ForegroundColor DarkRed
    }     
    Write-Host "Ubicacion y nombre de los archivos PST" -ForegroundColor Yellow
    $outlook.Session.Stores | Where { ($_.Filepath -like '*.pst') } | Format-Table DisplayName , FilePath -AutoSize 
}


Set-Variable -Name fin -Scope Global -Value $False  #variable que indica el fin del script
get-pst

<# Mientras la variable fin sea FALSE pedirá un archivo , si ya se pidió preguntará si se quiere importar otro archivo PST #>
While ($fin -eq $false){
    if ((Get-FileName) -eq $False)
     {
         Write-Host "No se ha seleccionado ningun archivo PST!" -ForegroundColor Red
         $a = new-object -comobject wscript.shell
         $a.popup("No se ha seleccionado ningun archivo PST!",0,"FAIL",48+0) | Out-Null
         if ((get-another) -eq $true){
                Set-Variable -Name file -Scope Global -Value ""
        }
     }
     else{
      Add-type -assembly "Microsoft.Office.Interop.Outlook" | out-null
      $out = new-object -comobject outlook.application
      $name = $out.GetNameSpace("MAPI")
      $name.AddStore($file) 
      get-another
     }
 }
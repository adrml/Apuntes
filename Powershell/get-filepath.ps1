#Autor:Adrián Milán

#Script que abre una ventana para pedir un solo archivo , almacena la ruta absoluta de este en una variable y devuelve
#la variable o un error.

Function Get-FileName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog #Crea el objeto ventana
    $OpenFileDialog.initialDirectory = $initialDirectory #parametro de la ubicacion al abrir la ventana
    #$openfiledialog.InitialDirectory = [System.IO.Directory]::GetCurrentDirectory() #abrir ventana en el path de ejecuccion del script
    $OpenFileDialog.Title = "Selecciona tu archivo"      #Titulo de la ventana
    $openFileDialog.filter = "Todo :)|*.*|CSV (*.csv)|*.csv " #filtro de archivos posibles para seleccionar
    $OpenFileDialog.ShowDialog() | Out-Null  #Muestra la ventana al usuario y espera selección
    Set-Variable -Name file -Value $OpenFileDialog.FileName #variable almacen de ruta absoluta al archivo

   #Si la variable que contiene la ruta esta vacia mostrar error, sino mostrar ruta del archivo.
    if ([string]::IsNullOrEmpty($file)){
        return Write-Host "No se ha seleccionado ningun archivo , god of trolling" -ForegroundColor Red
    }
    else{
        return Write-Host "El archivo seleccionado es:" -ForegroundColor Green $file
    }

}

#Llamada a la funcion
Get-FileName

#Llamada a la funcion indicando path de la ventana
#Get-FileName "C:\ejemplo"



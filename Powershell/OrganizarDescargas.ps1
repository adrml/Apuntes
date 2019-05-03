#Limpiar archivos acumulados en descargas 

$Filepath = "C:\Users\Adrian\Downloads"
$file = ""
$date  = ""
$month   = ""
$year    = ""
$MonthPath   = ""

#$FilePath = Read-Host "Inserte el directorio que quiere organizar"

$extensions='.doc','.docx','.xlsx' ,'.msg','.pdf','.jpg','.png','.xls','.docm','.xlsm','.odt'


Write-Warning "Esta acción puede tardar un tiempo, dependiendo de la cantidad y peso de archivos en: $FilePath."

get-childitem $FilePath | Select-Object -Property * | Where-Object { $_.Extension -in $extensions }  | % {

  $file = $_.FullName 
    $date = Get-Date ($_.LastWriteTime)

  $month = $date.month
  $year = $date.year
  $day = $date.day
    $MonthPath = "$FilePath\OLD\$year.$month.$day"
    Write-Verbose "month = $month"
    Write-Verbose "Date = $date"
    Write-Verbose "year = $year"
    Write-Verbose "FilePath = $FilePath" 
    Write-Verbose "Filename = $file"
    Write-Verbose "MonthPath = $MonthPath"
    if ($_.LastWriteTime -lt (Get-Date).AddDays(-2)) {
        if(!(Test-Path -Path "$MonthPath" )){
            Write-Verbose "Creando la carpeta $MonthPath."
            Write-Host -backgroundcolor black -ForegroundColor green "Creando la carpeta $MonthPath."
            New-Item -ItemType directory -Path $MonthPath | Out-null
        }
        else {
            Write-Host -backgroundcolor black -ForegroundColor yellow "El path $MonthPath ya existía"
            Write-Verbose "El path $MonthPath ya existía" 
            }
        move-item "$file" "$MonthPath" | Out-null
        }
    }

Write-Information "Los archivos se han organizado correctamente."

#Ocultar swaps generadas por vim en la carpeta Documentos
#Get-ChildItem -Path "C:\Users\Adrian\Documents" -Name "*~"  | % { attrib +h $_ }
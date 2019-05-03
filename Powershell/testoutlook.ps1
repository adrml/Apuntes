#Obtener el nombre del perfil por defecto en Outlook 2016
$OutlookApp = New-Object -ComObject 'Outlook.Application'
$OutlookApp.Application.DefaultProfileName


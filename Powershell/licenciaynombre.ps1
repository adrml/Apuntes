#Autor:Adrián Milán

##############Script encargado de recoger Nombre de equipo y codigo de licencia en un equipo ###############
############## con win8 , win8.1 o win.10 instalado.                                         ###############

#importacion del modulo encargado de  recoger la licencia.
Import-Module -DisableNameChecking $PSScriptRoot\dependencias\lic.ps1

#dependencias para los mensajes al usuario
Add-Type -AssemblyName System.Windows.Forms

#Codigo que almacena la licencia en la variable license 
$license = GetWin10Key
if ($license -eq $null)
{
    $license = "No hay licencias activas"
    [System.Windows.Forms.MessageBox]::Show($license,'Licencia del equipo','ok','warning')
}


#Se imprime la variable del sistema que contiene el nombre del equipoy la variable license con el codigo de activacion.
$msg = "Equipo: $env:COMPUTERNAME su licencia es --> $license"
echo $msg >> listado.txt
$len = $msg.Length
$div = "=" * $len
echo $div >> listado.txt



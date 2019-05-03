#Autor:Adrián Milán Caneda

        <# Este script esta pensado para hacer un borrado automatico de discos 
           Detectará la conexión del disco y si este no es el disco en la posicion 0 lo formateara al conectarse uno nuevo.
           El formateo requiere de interaccion con el usuario por el momento en la v0.1 , preguntará si estas seguro antes de formatearlo.
        #>


Unregister-Event -SourceIdentifier volumeChange -ea SilentlyContinue 
Register-WmiEvent -Class win32_VolumeChangeEvent -SourceIdentifier volumeChange
write-host (get-date -format s) " Arranque del script..."*
do
{
    $newEvent = Wait-Event -SourceIdentifier volumeChange
    $eventType = $newEvent.SourceEventArgs.NewEvent.EventType
    $eventTypeName = switch($eventType)
    {
        1 {"El disco ha cambiado"}
        2 {"Disco conectado"}
        3 {"Disco desconectado"}
        4 {"docking"}
    }
    Write-host  (get-date -format s) " Se ha producido un evento = " -nonewline ; Write-host -BackgroundColor Black -ForegroundColor Yellow $eventTypeName
    if ($eventType -eq 2)
    {
        $driveLetter = $newEvent.SourceEventArgs.NewEvent.DriveName
        $driveLabel = ([wmi]"Win32_LogicalDisk='$driveLetter'").VolumeName
        #write-host (get-date -format s) " Letra del disco = " $driveLetter
        #write-host (get-date -format s) " Nombre = " $driveLabel
        $disks = get-disk 
        # Ejecuta un procedimiento si la cantidad de discos es superior a 1  
        if (($disks).count -gt 1 )
        {
            #write-host (get-date -format s) " Empezando a formatear en 3 segundos."
            #start-sleep -seconds 3
            foreach($disk in $disks | Where-Object {$_.number -ne 0})
            {
                Write-Host (get-date -format s) " Se va a formatear el disco " $disk.number 
                #Write-Host (get-date -format s) -NoNewline; Write-Host -BackgroundColor Black -ForegroundColor White "Presione una tecla para formatear el disco"
                #Read-Host
                Clear-Disk -Number $disk.Number -RemoveData -RemoveOEM -ErrorAction SilentlyContinue  
                if ($? -eq $True)
                {
                    Write-Host (get-date -format s)-NoNewline ; Write-Host -BackgroundColor Black -ForegroundColor Green " Disco formateado correctamente"
                }
                else
                {
                    Write-Host (get-date -format s)-NoNewline ; Write-Host -BackgroundColor Black -ForegroundColor Red " Ha habido algun problema al formatear el disco"
                }
            }
    
        }
    }
Remove-Event -SourceIdentifier volumeChange
} while (1-eq1) #bucle hasta el proximo evento
Unregister-Event -SourceIdentifier volumeChange
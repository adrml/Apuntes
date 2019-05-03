function checkShutdown
{
    $event = Get-EventLog -LogName System  -EntryType Information , Warning -source User32  | Select -First 1 
    if ($event.EventID -eq 1075){
        return "El ultimo apagado se canceló"
    }
    else{
        if ($event.TimeWritten -match "(\d{2}|\d):\d{2}:\d{2}"){
        #Extraccion de la hora a la que se programó el apagado para calculos
        $eventTime = $matches[0]
        }
        else {
                return "No hay ningún apagado programado"
        } 
        #Extraccion de los segundos a los que se programó el apagado
        #Write-Host $event.message
        if ($event.message -match "\d+$"){
            $shutdownseconds = $matches[0]
    #        Write-Host $shutdownseconds
            }
        else {
    #        Write-Host $event.message
            $Error = "No hay ningún apagado programado"
            return $Error 
            }
        
        #Write-Host $eventTime
        $eventTime = [datetime]::ParseExact($eventTime, 'HH:mm:ss',$null)
        
        #convertido a formato fecha se añade el tiempo de apagado
        $Time = $eventTime.AddSeconds($shutdownseconds)
        return $Time
    }
}
checkshutdown

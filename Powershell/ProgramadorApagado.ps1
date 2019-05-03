#Script encargado de programar apagado mediante una GUI
#Autor: Adrián Milán 
#Fecha: 17/11/2018
#Version: 0.1

function checkshutdown
{
    $event = Get-EventLog -LogName System  -EntryType Information , Warning -source User32 ,EventLog |Where-Object {$_.EventID -eq 1075 -or $_.EventID -eq 1074 -or $_.EventID -eq 6006 -or $_.EventID -eq 6005 } | Select-Object -Last 1 
    if ($event.EventID -eq 1075)
    {
        return "El ultimo apagado se canceló"
    }
    elseif ($event.EventID -eq 6006)
     {
        return "El ultimo apagado fue a mano"
     }
    elseif ($event.EventID -eq 6005)
     {
        return "Bienvenid@ al programador de apagado"
     }
    else{
        #if ($event.TimeWritten.DateTime -match "(\d{2}|\d):\d{2}:\d{2}$")
            #{
                ##Extraccion de la hora a la que se programó el apagado para calculos
               #$eventTime = $matches[0]
                ##$eventTime = $event.TimeWritten.Date
            #}
        #else {
                #return "No hay ningún apagado programado"
             #} 

        #Extraccion de los segundos a los que se programó el apagado
        if ($event.message -match "\d+$" -and $event.EventID -eq 1074)
            {
                $shutdownseconds = $matches[0]
            }
        else {
                $Fallo = "No hay ningún apagado programado"
                return $Fallo
             }
        
        #Write-Host $eventTime
        #$eventTime = [datetime]::ParseExact($eventTime, 'HH:mm:ss',$null)
        
        #convertido a formato fecha se añade el tiempo de apagado
        #$Time = $eventTime.AddSeconds($shutdownseconds)
        #$Tiempo = "Programado para: " + $Time
        $script:Tiempo = (Get-date).AddSeconds($shutdownseconds)
        $script:Tiempo = $Tiempo.DateTime
        return $script:Tiempo
        }
}

#Carga de clases .NET
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Data
Add-Type -AssemblyName PresentationFramework
$Global:Tiempo


#Nueva instancia de la clase (nueva ventana)
$form = New-Object System.Windows.Forms.Form

#asignacion de valores a la nueva instancia
$form.Text = 'Programar apagado del equipo' #Titulo de la ventana
$form.Font = "Comic Sans"
$form.Size = New-Object System.Drawing.Size(350,250) #tamaño de la ventana , ancho por alto
$form.StartPosition = 'CenterScreen'  #posicion de inicio de la ventana
$form.Icon = 'C:\Users\Usuario\Desktop\SARA\ico.ico'
$form.MinimizeBox = $false
$form.MaximizeBox = $false
$form.ShowInTaskbar = $true
#$form.BackColor = "LightPink"
$form.FormBorderStyle = 'Fixed3D'

#Creación del botón aceptar
$OKButton = New-Object System.Windows.Forms.Button #nueva instancia del boton
$OKButton.Location = New-Object System.Drawing.Point(80,150) #posicion del boton  borde izquierdo , borde superior)
$OKButton.Size = New-Object System.Drawing.Size(75,23) #tamaño del boton
$OKButton.Text = 'Programar'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$OKButton.Font = "Comic Sans"


#Creación del botón cancelar
$CancelButton = New-Object System.Windows.Forms.Button #nueva instancia del botón 
$CancelButton.Location = New-Object System.Drawing.Point(180,150)#posicion del boton  borde izquierdo , borde superior)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancelar"
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::No
$CancelButton.Font = "Comic Sans"


#inclusion del los botones a la ventana
$form.CancelButton = $CancelButton
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)
$form.Controls.Add($CancelButton)


#Creacion de la etiqueta que informa al usuario que debe hacer
 $label = New-Object System.Windows.Forms.Label
 $label.Location = New-Object System.Drawing.Point(20,20)
 $label.Size = New-Object System.Drawing.Size(285,30)
 $label.TextAlign = "MiddleCenter"
 $label.text = 'Introduce la hora a la que quieres que se apague el portatil'
 $label.Font = "Comic Sans"

#Creación de la etiqueta que informa al usuario sobre la programación de apagado actual 
#2 opciones : Hora y dia de apagado / El ultimo apagado se canceló
$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(60,60)#posicion del boton  borde izquierdo , borde superior)
$label2.Size = New-Object System.Drawing.Size(230,30)
$label2.TextAlign = "MiddleCenter"
$label2.Font = "Comic Sans"
$label2.Text =  checkshutdown

 #inclusion de las etiquetas
 $form.Controls.Add($label)
 $form.Controls.Add($label2)

 #Creacion del selector de tiempo
 $timer = New-Object System.Windows.Forms.DateTimePicker
 $timer.Format = 'Time'
 $timer.CustomFormat = "HH:m:s - d/M/yy"
 $timer.Size = New-Object System.Drawing.Point(130,70)
 $timer.Location = New-Object System.Drawing.Point(110,100)
 $timer.CalendarTitleBackColor = "Pink"
 $timer.CalendarForeColor = "white"
 $timer.CalendarMonthBackground = "Gray"
 $timer.CalendarFont = "Comic Sans" 
 $timer.DropDownAlign = "Left"
 $check = checkshutdown
 if ($check -like "*apagado*")
    {
        $timer.Enabled = $True
    }
else {
    $timer.Enabled = $false
}

 #Inclusion del selector de hora
 $form.Controls.Add($timer)

 $form.TopMost = $true
 $result = $form.ShowDialog()
 $target = $timer.Value


if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        #Write-Host $target 
        $actual = Get-Date  
        $diff = ([math]::Round((New-TimeSpan -Start $actual -End $target).TotalSeconds))
        #$m1 = "El ordenador se apagará el: `n `n" + $target.DateTime +"`n `nBuenas noches GUAPA! :* "
        shutdown /s /t $diff /c $diff
        #[System.Windows.MessageBox]::Show($m1, "`t Bonaniit",'ok','Information')
    }
elseif ($result -eq [System.Windows.Forms.DialogResult]::No) 
    {
        shutdown /a
        $m2 = "Se ha cancelado el apagado programado para: `n `n" + $Global:Tiempo +"`n `n Hasta otra :D "
        [System.Windows.MessageBox]::Show($m2, "`t Apagado automático cancelado",'ok','Information')
    }
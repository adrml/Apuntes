Set-Location -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
Move-Item .\Skype\Skype.lnk -Destination .\
Move-Item '.\VideoLAN\VLC media player.lnk' -Destination .\
Move-Item .\WinRAR\WinRAR.lnk -Destination .\
Remove-Item -Recurse .\Skype , .\VideoLAN , .\WinRAR
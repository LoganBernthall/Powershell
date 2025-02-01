#PS Script which updates Windows PC and Reboots PC
Install-Module PSWindowsUpdate -Force -Scope CurrentUser
Get-WindowsUpdate
Install-WindowsUpdate -AcceptAll -AutoReboot

#Monitor TCP Connections
while ($true) {Get-NetTCPConnection; Start-Sleep -Seconds 5}

Restart-Service -Name Dnscache -Force
Clear-DnsClientCache
Write-Host "DNS Service restarted and cache flushed successfully." -ForegroundColor Green
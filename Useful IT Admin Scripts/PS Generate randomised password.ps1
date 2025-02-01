$Password = -join ((33..126) | Get-Random -Count 12 | ForEach-Object {[char]$_}) #Generate randomm password stored in a variable

Write-Output "The password is $password"  
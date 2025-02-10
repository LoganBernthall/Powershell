$NetConf = Get-NetIPConfiguration | Select-Object InterfaceAlias, IPv4Address, IPv6Address, DNSServer, InterfaceDescription, @{Name="Gateway";Expression={$_.IPv4DefaultGateway}}, @{Name="MACAddress";Expression={(Get-NetAdapter -InterfaceIndex $_.InterfaceIndex).MacAddress}}

Write-Output "Current Computer Network Configuration: `n"  
$NetConf
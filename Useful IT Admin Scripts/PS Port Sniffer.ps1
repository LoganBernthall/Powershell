# Define target IP and port range
$TargetIP = "192.168.0.75"
$StartPort = 1
$EndPort = 1024

# Function to check open ports
function Test-Port {
    param ($ip, $port)
    try {
        $tcp = New-Object System.Net.Sockets.TcpClient
        $tcp.Connect($ip, $port)
        if ($tcp.Connected) {
            Write-Output "Open Port: $port"
            $tcp.Close()
        }
    } catch {
        # Port is closed or filtered, do nothing
    }
}

# Scan the port range
Write-Output "Scanning $TargetIP for open ports..."
$StartPort..$EndPort | ForEach-Object { Test-Port -ip $TargetIP -port $_ }
Write-Output "Scan complete."
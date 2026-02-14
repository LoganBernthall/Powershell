<#  
*Created By - Logan Bernthall - 01/02/2026
*Part of my M5StckProject, Powershell script used to collect sys metrics
#> 

function GetCPUParams
{

#Get CPU Load
$TotalLoads = (wmic cpu get LoadPercentage |
    Select-Object -Skip 1 |
    Where-Object { $_ -match '\d+' } |
    ForEach-Object { [int]$_ }
)

$TotalTemp = Get-CimInstance -Namespace root/wmi -ClassName MsAcpi_ThermalZoneTemperature |
    Select-Object -First 1 -ExpandProperty CurrentTemperature |
    ForEach-Object { "{0} C" -f [math]::Round(($_ - 2732) / 10) }

    return @{
        CPU  = $TotalLoads
        Temp = $TotalTemp
    }

}

function GetRAMParams
{

#Get Ram usage
$TotalUsage = (Get-CimInstance -ClassName CIM_OperatingSystem).FreePhysicalMemory / 1024

return [math]::Round($TotalUsage)

}

Function FormatToJSON
{
#Converts to JSON format
    
    $cpu = GetCPUParams
    $ram = GetRAMParams

    [PSCustomObject]@{
        Temp     = $cpu.Temp
        RamFree  = $ram
        CPU      = $cpu.CPU
    }

}

#Loop every 5 seconds - Deprecated but kept for testing of data loop
#while ($true) {FormatToJSON | ConvertTo-Json -Compress; Start-Sleep -Seconds 5}

#Creating HTTP Server
$Listener = New-Object System.Net.HttpListener
$Listener.Prefixes.Add("http://+:5000/")
$Listener.Start()

Write-Host "HTTP server running on port 5000"
Write-Host "Endpoint: /stats"

while ($Listener.IsListening) {

    $Context  = $Listener.GetContext()
    $request  = $Context.Request
    $Response = $Context.Response

    if ($request.Url.AbsolutePath -eq "/stats") {

        $JSON = FormatToJSON | ConvertTo-Json -Compress
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($JSON)

        $Response.ContentType = "application/json"
        $Response.ContentLength64 = $Buffer.Length
        $Response.OutputStream.Write($Buffer, 0, $Buffer.Length)

    }
    else {
        $Response.StatusCode = 404
    }

    $response.OutputStream.Close()
}

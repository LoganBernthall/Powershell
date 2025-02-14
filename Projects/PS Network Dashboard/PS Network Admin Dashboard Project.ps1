#Powershell project to perform network functions and act as a network monitor

#Load Assemblys
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms.DataVisualization

#Create Form Base
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Network Monitor"
$Form.Size = New-Object System.Drawing.Size(1000, 700)
$Form.StartPosition = "CenterScreen"

# Create the Label for basic functions
$LblBasicFunc = New-Object System.Windows.Forms.Label
$LblBasicFunc.Location = New-Object System.Drawing.Point(5, 10)
$LblBasicFunc.Size = New-Object System.Drawing.Size(180, 30)  # Adjusted height for text visibility
$LblBasicFunc.Font = New-Object System.Drawing.Font("Arial", 15, [System.Drawing.FontStyle]::Bold)
$LblBasicFunc.Text = "Basic Functions:"

# Add the Label to the Form
$Form.Controls.Add($LblBasicFunc)

#Create buttonb for retrieving network configuration
$GetNetConfigButton = New-Object System.Windows.Forms.Button
$GetNetConfigButton.Text = "Show Network Configuration"
$GetNetConfigButton.Size = New-Object System.Drawing.Size(150, 40)
$GetNetConfigButton.Location = New-Object System.Drawing.Point(15, 50)
$GetNetConfigButton.Add_Click({
    $NetConf = Get-NetIPConfiguration | Select-Object InterfaceAlias, IPv4Address, IPv6Address, DNSServer, InterfaceDescription, @{Name="Gateway";Expression={$_.IPv4DefaultGateway}}, @{Name="MACAddress";Expression={(Get-NetAdapter -InterfaceIndex $_.InterfaceIndex).MacAddress}}
    [System.Windows.Forms.MessageBox]::Show(($NetConf | Out-String), "Network Configuration")
})
$Form.Controls.Add($GetNetConfigButton)

#Network chart
# Create the chart
$chart = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
$chart.Width = 550
$chart.Height = 300
$chart.Left = 20
$chart.Top = 20

# Create chart area
$chartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
$chart.ChartAreas.Add($chartArea)

# Create the series
$series = New-Object System.Windows.Forms.DataVisualization.Charting.Series
$series.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$series.Name = "Network Usage"
$chart.Series.Add($series)

# Add chart to form
$form.Controls.Add($chart)

# Function to get network usage
function Get-NetworkUsage {
    try {
        $netStats = Get-Counter '\\Network Interface(*)\\Bytes Total/sec' | Select-Object -ExpandProperty CounterSamples
        if ($netStats -and $netStats.CookedValue -ne $null) {
            return [math]::Round(($netStats.CookedValue / 1024), 2)  # Convert to KB/s
        } else {
            return 0  # Return 0 if no valid data
        }
    } catch {
        return 0  # Return 0 in case of an error
    }
}

# Timer to update graph
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000  # 1 second interval
$timer.Add_Tick({
    $usage = Get-NetworkUsage
    if ($series.Points.Count -ge 30) {
        $series.Points.RemoveAt(0)  # Keep graph at 30 points
    }
    $series.Points.AddY($usage)
    $chart.Invalidate()
})

# Start updating
$timer.Start()

#Show The Form
$Form.ShowDialog()


#Powershell project to perform network functions and act as a network monitor

#Load Assemblys
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms.DataVisualization
Add-Type -AssemblyName Microsoft.VisualBasic

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

#Create buttonn for retrieving network configuration
$GetNetConfigButton = New-Object System.Windows.Forms.Button
$GetNetConfigButton.Text = "Show Network Configuration"
$GetNetConfigButton.Size = New-Object System.Drawing.Size(150, 40)
$GetNetConfigButton.Location = New-Object System.Drawing.Point(15, 50)
$GetNetConfigButton.Add_Click({
    $NetConf = Get-NetIPConfiguration | Select-Object InterfaceAlias, IPv4Address, IPv6Address, DNSServer, InterfaceDescription, @{Name="Gateway";Expression={$_.IPv4DefaultGateway}}, @{Name="MACAddress";Expression={(Get-NetAdapter -InterfaceIndex $_.InterfaceIndex).MacAddress}}
    [System.Windows.Forms.MessageBox]::Show(($NetConf | Out-String), "Network Configuration")
})
$Form.Controls.Add($GetNetConfigButton)

#Create button to perform GPUPDATE
$GetGPUPDATE = New-Object System.Windows.Forms.Button
$GetGPUPDATE.Text = "GPUPDATE"
$GetGPUPDATE.Size = New-Object System.Drawing.Size(150, 40)
$GetGPUPDATE.Location = New-Object System.Drawing.Point(15, 100)
$GetGPUPDATE.Add_Click({
    gpupdate /force
    [System.Windows.Forms.MessageBox]::Show(("GPUPDATE Complete" | Out-String), "GPUPDATE")
})
$Form.Controls.Add($GetGPUPDATE)

#Ping Google.com
$GetPingGoog = New-Object System.Windows.Forms.Button
$GetPingGoog.Text = "Ping Google"
$GetPingGoog.Size = New-Object System.Drawing.Size(150, 40)
$GetPingGoog.Location = New-Object System.Drawing.Point(15, 150)
$GetPingGoog.Add_Click({
    $NetTest = Test-Connection -ComputerName google.com -Count 4
    [System.Windows.Forms.MessageBox]::Show(($NetTest | Out-String), "GPUPDATE")
})
$Form.Controls.Add($GetPingGoog)

#Flush DNS
$GetFlushDNS = New-Object System.Windows.Forms.Button
$GetFlushDNS.Text = "Flush DNS"
$GetFlushDNS.Size = New-Object System.Drawing.Size(150, 40)
$GetFlushDNS.Location = New-Object System.Drawing.Point(15, 200)
$GetFlushDNS.Add_Click({
    $DNSFlush = ipconfig /flushdns
    [System.Windows.Forms.MessageBox]::Show(($DNSFlush | Out-String), "DNS Flush")
})
$Form.Controls.Add($GetFlushDNS)

#####################################################################Advanced Functions

# Create the Label for advanced functions
$LblAdvancedFunc = New-Object System.Windows.Forms.Label
$LblAdvancedFunc.Location = New-Object System.Drawing.Point(250, 10)
$LblAdvancedFunc.Size = New-Object System.Drawing.Size(300, 30)  # Adjusted height for text visibility
$LblAdvancedFunc.Font = New-Object System.Drawing.Font("Arial", 15, [System.Drawing.FontStyle]::Bold)
$LblAdvancedFunc.Text = "Advanced Functions:"

# Add the Label to the Form
$Form.Controls.Add($LblAdvancedFunc)

#Port Sniffer 
$PortSniff = New-Object System.Windows.Forms.Button
$PortSniff.Text = "Port Sniffer"
$PortSniff.Size = New-Object System.Drawing.Size(150, 40)
$PortSniff.Location = New-Object System.Drawing.Point(250, 50)
$PortSniff.Add_Click({
    $IP = [Microsoft.VisualBasic.Interaction]::InputBox("Enter IP Address:", "IP Address Input", "")
    # Define target IP and port range
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
                [System.Windows.Forms.MessageBox]::Show(($port | Out-String), "Open Port")
            }
        } catch {
            # Port is closed or filtered, do nothing
        }
    }

    # Scan the port range
    #Write-Output "Scanning $IP for open ports..."
    #$StartPort..$EndPort | ForEach-Object { Test-Port -ip $IP -port $_ }
    #Write-Output "Scan complete."
    
})
$Form.Controls.Add($PortSniff)

#Manage Inbound Firewall Rules
$FirewallList = New-Object System.Windows.Forms.ListBox
$FirewallList.Location = New-Object System.Drawing.Point(500, 70)
$FirewallList.Size = New-Object System.Drawing.Size(440, 200)
$form.Controls.Add($FirewallList)

#Enable Button For Listbox
$EnableButton = New-Object System.Windows.Forms.Button
$EnableButton.Text = "Enable Rule"
$EnableButton.Location = New-Object System.Drawing.Point(500, 45)
$EnableButton.Add_Click({
    if ($FirewallList.SelectedItem) {
        Set-NetFirewallRule -DisplayName $FirewallList.SelectedItem -Enabled True
        [System.Windows.Forms.MessageBox]::Show("Enabled: $($FirewallList.SelectedItem)", "Firewall Manager")
    }
})
$form.Controls.Add($EnableButton)

#Disable Button For Listbox
$DisableButton = New-Object System.Windows.Forms.Button
$DisableButton.Text = "Disable Rule"
$DisableButton.Location = New-Object System.Drawing.Point(600, 45)
$DisableButton.Add_Click({
    if ($FirewallList.SelectedItem) {
        Set-NetFirewallRule -DisplayName $FirewallList.SelectedItem -Enabled False
        [System.Windows.Forms.MessageBox]::Show("Disabled: $($FirewallList.SelectedItem)", "Firewall Manager")
    }
})
$form.Controls.Add($DisableButton)

$ManageFirewall = New-Object System.Windows.Forms.Button
$ManageFirewall.Text = "Firewall Manager"
$ManageFirewall.Size = New-Object System.Drawing.Size(150, 40)
$ManageFirewall.Location = New-Object System.Drawing.Point(250, 100)
$ManageFirewall.Add_Click({ 
    $FirewallList.Items.Clear()
    $Rules = Get-NetFirewallRule -Direction Inbound | Select-Object -ExpandProperty DisplayName
    $rules | ForEach-Object { $FirewallList.Items.Add($_) }
})

$Form.Controls.Add($ManageFirewall)
#############################Chart#################################

# Network chart
$chart = New-Object System.Windows.Forms.DataVisualization.Charting.Chart
$chart.Width = 550
$chart.Height = 300
$chart.Left = $form.ClientSize.Width - $chart.Width - 20
$chart.Top = $form.ClientSize.Height - $chart.Height - 20

# Set chart background to white for better visibility
$chart.BackColor = [System.Drawing.Color]::White

# Create chart area
$chartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
$chartArea.BackColor = [System.Drawing.Color]::White
$chart.ChartAreas.Add($chartArea)

# Configure chart area
$chartArea.AxisX.LabelStyle.Format = "HH:mm:ss"
$chartArea.AxisX.IntervalType = [System.Windows.Forms.DataVisualization.Charting.DateTimeIntervalType]::Seconds
$chartArea.AxisX.Interval = 1
$chartArea.AxisY.Minimum = 0
$chartArea.AxisY.Interval = 50  
$chartArea.AxisX.MajorGrid.LineColor = [System.Drawing.Color]::LightGray
$chartArea.AxisY.MajorGrid.LineColor = [System.Drawing.Color]::LightGray

# Create the series
$series = New-Object System.Windows.Forms.DataVisualization.Charting.Series
$series.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$series.Name = "Network Usage"
$series.XValueType = [System.Windows.Forms.DataVisualization.Charting.ChartValueType]::Time
$series.Color = [System.Drawing.Color]::Blue  # Set color for visibility
$series.BorderWidth = 2  # Increase line width for better visibility
$chart.Series.Add($series)

# Add an initial dummy data point **AFTER** series is created
$initialTime = [DateTime]::Now.ToOADate()
$series.Points.AddXY($initialTime, 0)

# Ensure the chart position updates when form resizes
$form.Add_Resize({
    $chart.Left = $form.ClientSize.Width - $chart.Width - 20
    $chart.Top = $form.ClientSize.Height - $chart.Height - 20
})

# Add chart to form
$form.Controls.Add($chart)

# Function to get network usage
function Get-NetworkUsage {
    try {
        $netStats = Get-Counter '\\Network Interface(*)\\Bytes Total/sec' | Select-Object -ExpandProperty CounterSamples
        if ($netStats -and $null -ne $netStats.CookedValue) {
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
    $time = [DateTime]::Now.ToOADate()  # Convert current time to OADate for chart X values
    
    if ($series.Points.Count -ge 30) {
        $series.Points.RemoveAt(0)  # Keep graph at 30 points
    }
    
    $series.Points.AddXY($time, $usage)
    $chart.ChartAreas[0].RecalculateAxesScale()
    $chart.Invalidate()
})

# Start updating
$timer.Start()

#Show The Form
$Form.ShowDialog()


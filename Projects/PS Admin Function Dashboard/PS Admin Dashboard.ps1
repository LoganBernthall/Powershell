# Load Required Assemblys
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the main form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "IT Admin Dashboard UI"
$Form.Size = New-Object System.Drawing.Size(500, 350)
$Form.StartPosition = "CenterScreen"

# Create the Label for basic functions
$LblBasicFunc = New-Object System.Windows.Forms.Label
$LblBasicFunc.Location = New-Object System.Drawing.Point(5, 10)
$LblBasicFunc.Size = New-Object System.Drawing.Size(180, 30)  # Adjusted height for text visibility
$LblBasicFunc.Font = New-Object System.Drawing.Font("Arial", 15, [System.Drawing.FontStyle]::Bold)
$LblBasicFunc.Text = "Basic Functions:"

# Add the Label to the Form
$Form.Controls.Add($LblBasicFunc)

# Create the Label for network functions
$LblNetFunc = New-Object System.Windows.Forms.Label
$LblNetFunc.Location = New-Object System.Drawing.Point(250, 10)
$LblNetFunc.Size = New-Object System.Drawing.Size(220, 30)  # Adjusted height for text visibility
$LblNetFunc.Font = New-Object System.Drawing.Font("Arial", 15, [System.Drawing.FontStyle]::Bold)
$LblNetFunc.Text = "Network Functions:"

# Add the Label to the Form
$Form.Controls.Add($LblNetFunc)


# Create a button for PC Info
$PCInfoButton = New-Object System.Windows.Forms.Button
$PCInfoButton.Text = "Show PC Info"
$PCInfoButton.Size = New-Object System.Drawing.Size(150, 40)
$PCInfoButton.Location = New-Object System.Drawing.Point(20, 50)
$PCInfoButton.Add_Click({
    $PCInfo = Get-ComputerInfo | Select-Object CsName, WindowsVersion, OsArchitecture, BiosVersion
    [System.Windows.Forms.MessageBox]::Show(($PCInfo | Out-String), "PC Info")
})
$Form.Controls.Add($PCInfoButton)

# Create a button to Check for Windows Updates
$CheckUpdatesButton = New-Object System.Windows.Forms.Button
$CheckUpdatesButton.Text = "Check for Updates"
$CheckUpdatesButton.Size = New-Object System.Drawing.Size(150, 40)
$CheckUpdatesButton.Location = New-Object System.Drawing.Point(20, 100)
$CheckUpdatesButton.Add_Click({
    try {
        Install-Module PSWindowsUpdate -Force -Scope CurrentUser
        Import-Module PSWindowsUpdate
        $Updates = Get-WindowsUpdate
        if ($Updates) {
            [System.Windows.Forms.MessageBox]::Show(($Updates | Out-String), "Available Updates")
        } else {
            [System.Windows.Forms.MessageBox]::Show("Your system is up to date!", "Windows Updates")
        }
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error checking updates: $_", "Error")
    }
})
$Form.Controls.Add($CheckUpdatesButton)

#Button for creating a randomised password generator

#Password generator button
$PasswordGeneratorButton = New-Object System.Windows.Forms.Button
$PasswordGeneratorButton.Text = "Create A User Password"
$PasswordGeneratorButton.Size = New-Object System.Drawing.Size(150, 40)
$PasswordGeneratorButton.Location = New-Object System.Drawing.Point(20, 150)
$PasswordGeneratorButton.Add_Click({
    
    $Password = -join ((33..126) | Get-Random -Count 18 | ForEach-Object {[char]$_})    #Generate randomm password stored in a variable
    [System.Windows.Forms.MessageBox]::Show(($Password | Out-String), "Password Generator")

}) 
    
###########################################Network Diagnostic Buttons
$NetworkGetIPEtcButton = New-Object System.Windows.Forms.Button
$NetworkGetIPEtcButton.Text = "Network Configuration"
$NetworkGetIPEtcButton.Size = New-Object System.Drawing.Size(150, 40)
$NetworkGetIPEtcButton.Location = New-Object System.Drawing.Point(200, 50)
$NetworkGetIPEtcButton.Add_Click({
    
    $NetConf = Get-NetIPConfiguration | Select-Object InterfaceAlias, IPv4Address, IPv6Address, DNSServer, InterfaceDescription, @{Name="Gateway";Expression={$_.IPv4DefaultGateway}}, @{Name="MACAddress";Expression={(Get-NetAdapter -InterfaceIndex $_.InterfaceIndex).MacAddress}}

    [System.Windows.Forms.MessageBox]::Show(($NetConf | Out-String), "Network Configuration")

}) 

$Form.Controls.Add($NetworkGetIPEtcButton)

############################## Create an Exit button
$ExitButton = New-Object System.Windows.Forms.Button
$ExitButton.Text = "Exit"
$ExitButton.Size = New-Object System.Drawing.Size(150, 40)
$ExitButton.Location = New-Object System.Drawing.Point(175, 220)
$ExitButton.Add_Click({ $Form.Close() })
$Form.Controls.Add($ExitButton)

# Show the Form
$Form.ShowDialog()

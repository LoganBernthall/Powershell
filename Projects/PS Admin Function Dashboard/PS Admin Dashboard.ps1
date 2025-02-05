# Load Windows Forms Assembly
Add-Type -AssemblyName System.Windows.Forms

# Create the main form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "IT Admin Dashboard UI"
$Form.Size = New-Object System.Drawing.Size(500, 350)
$Form.StartPosition = "CenterScreen"

# Create a button for PC Info
$PCInfoButton = New-Object System.Windows.Forms.Button
$PCInfoButton.Text = "Show PC Info"
$PCInfoButton.Size = New-Object System.Drawing.Size(150, 40)
$PCInfoButton.Location = New-Object System.Drawing.Point(175, 30)
$PCInfoButton.Add_Click({
    $PCInfo = Get-ComputerInfo | Select-Object CsName, WindowsVersion, OsArchitecture, BiosVersion
    [System.Windows.Forms.MessageBox]::Show(($PCInfo | Out-String), "PC Info")
})
$Form.Controls.Add($PCInfoButton)

# Create a button to Check for Windows Updates
$CheckUpdatesButton = New-Object System.Windows.Forms.Button
$CheckUpdatesButton.Text = "Check for Updates"
$CheckUpdatesButton.Size = New-Object System.Drawing.Size(150, 40)
$CheckUpdatesButton.Location = New-Object System.Drawing.Point(175, 80)
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
$PasswordGeneratorButton.Location = New-Object System.Drawing.Point(175, 130)
$PasswordGeneratorButton.Add_Click({
    
    $Password = -join ((33..126) | Get-Random -Count 18 | ForEach-Object {[char]$_})    #Generate randomm password stored in a variable
    [System.Windows.Forms.MessageBox]::Show(($Password | Out-String), "Password Generator")

}) 
    


$Form.Controls.Add($PasswordGeneratorButton)

# Create an Exit button
$ExitButton = New-Object System.Windows.Forms.Button
$ExitButton.Text = "Exit"
$ExitButton.Size = New-Object System.Drawing.Size(150, 40)
$ExitButton.Location = New-Object System.Drawing.Point(175, 180)
$ExitButton.Add_Click({ $Form.Close() })
$Form.Controls.Add($ExitButton)

# Show the Form
$Form.ShowDialog()

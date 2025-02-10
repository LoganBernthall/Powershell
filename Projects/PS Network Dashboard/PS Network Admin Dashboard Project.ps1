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

#Show The Form
$Form.ShowDialog()


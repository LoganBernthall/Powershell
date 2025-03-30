# A PuttyGen Lookalike encrypter in PowerShell

# Load Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create Form Base
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "PSGen"
$Form.Size = New-Object System.Drawing.Size(600, 500)
$Form.StartPosition = "CenterScreen"

# Create Label
$LblTitlePSGen = New-Object System.Windows.Forms.Label
$LblTitlePSGen.Location = New-Object System.Drawing.Point(250, 10)
$LblTitlePSGen.Size = New-Object System.Drawing.Size(180, 30) 
$LblTitlePSGen.Font = New-Object System.Drawing.Font("Arial", 15, [System.Drawing.FontStyle]::Bold)
$LblTitlePSGen.Text = "PSGen!"

# Add Label to the Form
$Form.Controls.Add($LblTitlePSGen)

# Create Label for 2048 RSA Encryption
$LblRSA2048PSGen = New-Object System.Windows.Forms.Label
$LblRSA2048PSGen.Location = New-Object System.Drawing.Point(20,40)
$LblRSA2048PSGen.Size = New-Object System.Drawing.Size(250, 30) 
$LblRSA2048PSGen.Font = New-Object System.Drawing.Font("Arial", 15, [System.Drawing.FontStyle]::Bold)
$LblRSA2048PSGen.Text = "RSA 2048 Encryption"

# Add Label to the Form
$Form.Controls.Add($LblRSA2048PSGen)

# Create RSA Button for public key encryption
$BtnCrtPubRSA2048 = New-Object System.Windows.Forms.Button
$BtnCrtPubRSA2048.Text = "Create Keys"
$BtnCrtPubRSA2048.Size = New-Object System.Drawing.Size(150, 40)
$BtnCrtPubRSA2048.Location = New-Object System.Drawing.Point(25, 70)
$BtnCrtPubRSA2048.Add_Click({

    # Generate RSA Keys
    $RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider(2048)
    $PublicKey = $RSA.ToXmlString($false)  # Public Key (no private details)
    $PrivateKey = $RSA.ToXmlString($true)  # Private Key (includes full key)

    # Function to open Save File Dialog
    function Get-SaveFilePath($title, $defaultName) {
        $SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
        $SaveFileDialog.Title = $title
        $SaveFileDialog.Filter = "XML Files (*.xml)|*.xml|All Files (*.*)|*.*"
        $SaveFileDialog.FileName = $defaultName

        if ($SaveFileDialog.ShowDialog() -eq "OK") {
            return $SaveFileDialog.FileName
        } else {
            return $null
        }
    }

    # Get save locations from user
    $PublicKeyPath = Get-SaveFilePath "Save Public Key As" "PublicKey.xml"
    $PrivateKeyPath = Get-SaveFilePath "Save Private Key As" "PrivateKey.xml"

    # Only save if user selected a path
    if ($PublicKeyPath -and $PrivateKeyPath) {
        # Save Keys
        $PublicKey | Out-File $PublicKeyPath
        $PrivateKey | Out-File $PrivateKeyPath

        # Show Confirmation Message Box
        [System.Windows.Forms.MessageBox]::Show("Keys have been saved to:`n$PublicKeyPath`n$PrivateKeyPath", "Confirmation", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } else {
        # User canceled save dialog
        [System.Windows.Forms.MessageBox]::Show("Key generation canceled.", "Canceled", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    }

})

# Add Button to the Form
$Form.Controls.Add($BtnCrtPubRSA2048)

# Show The Form
$Form.ShowDialog()

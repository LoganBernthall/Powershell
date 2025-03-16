#A PuttyGen Lookalike encrypter in PowerShell

#Load Assemblys
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Create Form Base
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "PSGen"
$Form.Size = New-Object System.Drawing.Size(600, 500)
$Form.StartPosition = "CenterScreen"

#Create Label
$LblTitlePSGen = New-Object System.Windows.Forms.Label
$LblTitlePSGen.Location = New-Object System.Drawing.Point(250, 10)
$LblTitlePSGen.Size = New-Object System.Drawing.Size(180, 30) 
$LblTitlePSGen.Font = New-Object System.Drawing.Font("Arial", 15, [System.Drawing.FontStyle]::Bold)
$LblTitlePSGen.Text = "PSGen!"

#Add Label to the Form
$Form.Controls.Add($LblTitlePSGen)

#Create Label for 2048 RSA Encryption
$LblRSA2048PSGen = New-Object System.Windows.Forms.Label
$LblRSA2048PSGen.Location = New-Object System.Drawing.Point(20,40)
$LblRSA2048PSGen.Size = New-Object System.Drawing.Size(250, 30) 
$LblRSA2048PSGen.Font = New-Object System.Drawing.Font("Arial", 15, [System.Drawing.FontStyle]::Bold)
$LblRSA2048PSGen.Text = "RSA 2048 Encryption"

#Add Label to the Form
$Form.Controls.Add($LblRSA2048PSGen)

#Create RSA Button for public key encryption
$BtnCrtPubRSA2048 = New-Object System.Windows.Forms.Button
$BtnCrtPubRSA2048.Text = "Create Keys"
$BtnCrtPubRSA2048.Size = New-Object System.Drawing.Size(150, 40)
$BtnCrtPubRSA2048.Location = New-Object System.Drawing.Point(25, 70)
$BtnCrtPubRSA2048.Add_Click({

    # Generate RSA Keys
    $RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider(2048)
    $PublicKey = $RSA.ToXmlString($false)  # Public Key (no private details)
    $PrivateKey = $RSA.ToXmlString($true)  # Private Key (includes full key)
    
    # Correct file paths (Downloads folder)
    $PrivateKeyPath = "$env:USERPROFILE\Downloads\PrivateKey.xml"
    $PublicKeyPath = "$env:USERPROFILE\Downloads\PublicKey.xml"
    
    # Save Keys
    $PublicKey | Out-File $PublicKeyPath
    $PrivateKey | Out-File $PrivateKeyPath
    
    # Show Confirmation Message Box
    [System.Windows.Forms.MessageBox]::Show("Keys have been saved to:`n$PublicKeyPath`n$PrivateKeyPath", "Confirmation", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    
})

#Add Label to the Form
$Form.Controls.Add($BtnCrtPubRSA2048)

#Show The Form
$Form.ShowDialog()

# A PuttyGen Lookalike encrypter in PowerShell

# Load Assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

#Pre-Req Variables
$global:PubVal = ""

#####################################Function Define Zone

#Success Indicator to show task completed
function SuccessIndicator {
    
    #Parameters
    param 
    (
        [string]$Task #Specify task 
    )
    
    #Function do
    [System.Windows.Forms.MessageBox]::Show( "Task: $Task Completed", "Confirmation", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

#Save functionality - Intially going to add save functionality in each button but that is cumbersome
#Innovating save functionality into a callable function
function SaveFunctionality {
    param (
        [string]$FileSavePath,
        [string]$FileSaveType,
        [string]$PublicKey,
        [string]$PrivateKey
    )

    function Get-SaveFilePath {
        param (
            [string]$title,
            [string]$defaultName
        )

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
    $PublicKeyPath = Get-SaveFilePath -title "Save Public Key As" -defaultName "PublicKey.xml"
    $PrivateKeyPath = Get-SaveFilePath -title "Save Private Key As" -defaultName "PrivateKey.xml"

    if ($PublicKeyPath -and $PrivateKeyPath) {
        $PublicKey | Out-File -FilePath $PublicKeyPath -Encoding UTF8
        $PrivateKey | Out-File -FilePath $PrivateKeyPath -Encoding UTF8

        [System.Windows.Forms.MessageBox]::Show(
            "Keys saved to:`n$PublicKeyPath`n$PrivateKeyPath",
            "Confirmation",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
    } else {
        [System.Windows.Forms.MessageBox]::Show(
            "Key generation canceled.",
            "Canceled",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
    }
}



################################################################################

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
$LblRSA2048PSGen.Text = "RSA 2048 Encryption:"

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
    
    SaveFunctionality -PublicKey $PublicKey -PrivateKey $PrivateKey 
    SuccessIndicator -Task "RSA"
})

# Add Button to the Form
$Form.Controls.Add($BtnCrtPubRSA2048)

#Create label for Secure Strings (AES)
$LblAES = New-Object System.Windows.Forms.Label
$LblAES.Location = New-Object System.Drawing.Point(20,120)
$LblAES.Size = New-Object System.Drawing.Size(250, 22) 
$LblAES.Font = New-Object System.Drawing.Font("Arial", 15, [System.Drawing.FontStyle]::Bold)
$LblAES.Text = "AES Encryption:"

# Add Label to the Form
$Form.Controls.Add($LblAES)

# Create RSA Button for public key encryption
$BtnCrtAES = New-Object System.Windows.Forms.Button
$BtnCrtAES.Text = "Create Keys"
$BtnCrtAES.Size = New-Object System.Drawing.Size(150, 40)
$BtnCrtAES.Location = New-Object System.Drawing.Point(25, 140)
$BtnCrtAES.Add_Click({ 
   
    # Create an AES object
    $AES = [System.Security.Cryptography.Aes]::Create()
    $AES.KeySize = 256  # Set key size to 256 bits (32 bytes)
    $AES.GenerateKey()  # Explicitly generate a random key
    
    # Convert the key to Base64 for easy storage/display
    $Base64Key = [Convert]::ToBase64String($AES.Key)

    #[System.Windows.Forms.MessageBox]::Show("AES Key (Base64): $Base64Key", "Confirmation", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    SaveFunctionality -FileSavePath "AESKey.txt" -FileSaveType ".txt" -PublicKey $Base64Key -PrivateKey ""
    SuccessIndicator -Task "AES"

    $PubVal = $PubVal + $AES
})


# Add Button to the Form
$Form.Controls.Add($BtnCrtAES)

# Create a label for a textbox to display the encryption key in (PUBLIC ONLY)
$LblEcnPubTxt = New-Object System.Windows.Forms.Label
$LblEcnPubTxt.Location = New-Object System.Drawing.Point(20,200)
$LblEcnPubTxt.Size = New-Object System.Drawing.Size(250, 50) 
$LblEcnPubTxt.Font = New-Object System.Drawing.Font("Arial", 15, [System.Drawing.FontStyle]::Bold)
$LblEcnPubTxt.Text = "Public Key Pasteboard:"

# Add Label to the Form
$Form.Controls.Add($LblEcnPubTxt)

# Create a textbox to display the encryption key in (PUBLIC ONLY)
$TbEcnPubTxt = New-Object System.Windows.Forms.TextBox
$TbEcnPubTxt.Location = New-Object System.Drawing.Point(20, 250)
$TbEcnPubTxt.Size = New-Object System.Drawing.Size(500, 500)
$TbEcnPubTxt.ReadOnly = $true
$TbEcnPubTxt.Text = $PubVal

#Add Textbox to form
$form.Controls.Add($TbEcnPubTxt)
# Show The Form
$Form.ShowDialog()

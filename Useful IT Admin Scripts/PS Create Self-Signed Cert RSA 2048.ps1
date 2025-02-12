#Creates a self-signed windows certificate placed into cert store and exports to a document for export

# Define certificate parameters
$CertName = "CN=MySelfSignedCert"
$CertPath = "Cert:\CurrentUser\My\"
$pfxPassword = ConvertTo-SecureString -String "P@ssw0rd!" -Force -AsPlainText
$PfxFile = "$env:USERPROFILE\Desktop\MyCert.pfx"
$CerFile = "$env:USERPROFILE\Desktop\MyCert.cer"
$ValidityPeriod = 365  # Certificate validity in days

# Create a self-signed certificate
$Cert = New-SelfSignedCertificate -Subject $CertName -KeyAlgorithm RSA -KeyLength 2048 -CertStoreLocation $CertPath -NotAfter (Get-Date).AddDays($ValidityPeriod) #Current - year long

# Export the certificate to a PFX file (with private key)
Export-PfxCertificate -Cert $Cert -FilePath $PfxFile -Password $pfxPassword

Write-Output "Certificate created and exported to:"
Write-Output "PFX: $PfxFile"
Write-Output "CER: $CerFile"
Write-Output "Validity: $ValidityPeriod days"
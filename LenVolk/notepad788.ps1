if ((Test-Path c:\temp) -eq $false) {
    Add-Content -LiteralPath C:\New-Binary.log "Create C:\temp Directory"
    Write-Host `
        -ForegroundColor Cyan `
        -BackgroundColor Green `
        "creating temp directory"
    New-Item -Path c:\temp -ItemType Directory
}
else {
    Add-Content -LiteralPath C:\New-Binary.log "C:\temp Already Exists"
    Write-Host `
        -ForegroundColor Yellow `
        -BackgroundColor Green `
        "temp directory already exists"
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Ssl3
[Net.ServicePointManager]::SecurityProtocol = "Tls, Tls11, Tls12, Ssl3"

invoke-webrequest -uri 'https://aka.ms/downloadazcopy-v10-windows' -OutFile 'c:\temp\azcopy.zip'
Expand-Archive 'c:\temp\azcopy.zip' 'c:\temp'
copy-item 'C:\temp\azcopy_windows_amd64_*\azcopy.exe\' -Destination 'c:\temp'

Add-Content -LiteralPath C:\New-Binary.log "downloaded azcopy to c:\temp"
Write-Host `
    -ForegroundColor Yellow `
    -BackgroundColor Green `
    "downloaded azcopy to c:\temp"


invoke-webrequest -uri 'https://pic.lvolk.com/npp.7.8.8.exe' -OutFile 'c:\temp\npp.7.8.8.exe'

Add-Content -LiteralPath C:\New-Binary.log "downloaded notepad v 7.8.8 to c:\temp"
Write-Host `
    -ForegroundColor Yellow `
    -BackgroundColor Green `
    "downloaded noptepad 7.8.8 to c:\temp"

Start-Process -filepath "C:\temp\npp.7.8.8.exe" -Wait -ErrorAction Stop -ArgumentList '/S'


### Deploy website ###
######################
# add web server with all features
Add-WindowsFeature -Name Web-Server -IncludeAllSubFeature

# clean www root folder
Remove-Item C:\inetpub\wwwroot\* -Recurse -Force

# download website zip
$ZipBlobUrl = 'https://pic.lvolk.com/Website.zip'
$ZipBlobDownloadLocation = 'c:\temp\Website.zip'

(New-Object System.Net.WebClient).DownloadFile($ZipBlobUrl, $ZipBlobDownloadLocation)

# extract downloaded zip
$UnzipLocation = 'C:\inetpub\wwwroot\'
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::ExtractToDirectory($ZipBlobDownloadLocation, $UnzipLocation)

# read write permission
$Path = "C:\inetpub\wwwroot\temp"
$User = "IIS AppPool\DefaultAppPool"
$Acl = Get-Acl $Path
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule($User, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$Acl.SetAccessRule($Ar)
Set-Acl $Path $Acl

# c:\temp\azcopy.exe copy "$blobUri$sasToken" c:\temp\$blob --overwrite true --recursive
# Expand-Archive "c:\temp\$blob" C:\Temp\

# Add-Content -LiteralPath C:\New-Binary.log "azcopy copy binary from blob to c:\temp and extract it"
# Write-Host `
#     -ForegroundColor Yellow `
#     -BackgroundColor Green `
#     "azcopy copy binary from blob to c:\temp and extract it"
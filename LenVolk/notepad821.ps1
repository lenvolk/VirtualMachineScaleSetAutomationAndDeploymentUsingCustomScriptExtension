invoke-webrequest -uri 'https://pic.lvolk.com/npp.8.2.1.exe' -OutFile 'c:\temp\npp.8.2.1.exe'

Add-Content -LiteralPath C:\New-Binary.log "downloaded notepad v 8.2.1 to c:\temp"
Write-Host `
    -ForegroundColor Yellow `
    -BackgroundColor Green `
    "downloaded noptepad 8.2.1 to c:\temp"

Start-Process -filepath "C:\temp\npp.8.2.1.exe" -Wait -ErrorAction Stop -ArgumentList '/S'


### Deploy website ###
######################

Add-WindowsFeature -Name Web-Server -IncludeAllSubFeature

# clean www root folder
Remove-Item C:\inetpub\wwwroot\* -Recurse -Force

# download website zip
$ZipBlobUrl = 'https://pic.lvolk.com/Website-Update1.zip'
$ZipBlobDownloadLocation = 'c:\temp\Website-Update1.zip'
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
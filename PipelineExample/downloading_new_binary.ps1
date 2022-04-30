
####################################
# Setup wvd agents
####################################


$blobUri = "<__param1__>"
$sasToken = "<__param2__>"
$blob = "<__param3__>"

Write-Host `
    -ForegroundColor Yellow `
    -BackgroundColor Green `
    write-host "##############wvd_downloading_new_binary################################"
write-host "blobUri set to: $blobUri"
write-host "&&&&&&& sasToken set to: $sasToken"
write-host "blob set to: $blob"


if ((Test-Path c:\temp) -eq $false) {
    Add-Content -LiteralPath C:\New-WVDBinary.log "Create C:\temp Directory"
    Write-Host `
        -ForegroundColor Cyan `
        -BackgroundColor Green `
        "creating temp directory"
    New-Item -Path c:\temp -ItemType Directory
}
else {
    Add-Content -LiteralPath C:\New-WVDBinary.log "C:\temp Already Exists"
    Write-Host `
        -ForegroundColor Yellow `
        -BackgroundColor Green `
        "temp directory already exists"
}

#T-Shooting
Add-Content -LiteralPath C:\New-WVDBinary.log "BlobUri is $blobUri AND sasToken is $sasToken AND blob is $blob"

invoke-webrequest -uri 'https://aka.ms/downloadazcopy-v10-windows' -OutFile 'c:\temp\azcopy.zip'
Expand-Archive 'c:\temp\azcopy.zip' 'c:\temp'
copy-item 'C:\temp\azcopy_windows_amd64_*\azcopy.exe\' -Destination 'c:\temp'

Add-Content -LiteralPath C:\New-WVDBinary.log "downloaded azcopy to c:\temp"
Write-Host `
    -ForegroundColor Yellow `
    -BackgroundColor Green `
    "downloaded azcopy to c:\temp"


c:\temp\azcopy.exe copy "$blobUri$sasToken" c:\temp\$blob --overwrite true --recursive
Expand-Archive "c:\temp\$blob" C:\Temp\

Add-Content -LiteralPath C:\New-WVDBinary.log "azcopy copy binary from blob to c:\temp and extract it"
Write-Host `
    -ForegroundColor Yellow `
    -BackgroundColor Green `
    "azcopy copy binary from blob to c:\temp and extract it"
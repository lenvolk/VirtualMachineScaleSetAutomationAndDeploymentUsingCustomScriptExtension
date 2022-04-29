
# Install Notepad++ v7.8.8
$customConfig = @{
    "fileUris"         = (, "https://raw.githubusercontent.com/lenvolk/AzVmssExtension/main/notepadv1.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File notepadv1.ps1"
}

$extensionname = "customScript"

# Get information about the scale set
$vmss = Get-AzVmss `
    -ResourceGroupName "JumpBox" `
    -VMScaleSetName "jumpvm"

# Use Custom Script Extension to install custom extension
Add-AzVmssExtension -VirtualMachineScaleSet $vmss `
    -Name $extensionname `
    -Publisher "Microsoft.Compute" `
    -Type "CustomScriptExtension" `
    -TypeHandlerVersion 1.10 `
    -Setting $customConfig

# Update the scale set and apply the Custom Script Extension to the VM instances
Update-AzVmss `
    -ResourceGroupName "JumpBox" `
    -Name "jumpvm" `
    -VirtualMachineScaleSet $vmss

#### Update Notepad++

$vmss = Get-AzVmss `
    -ResourceGroupName "JumpBox" `
    -VMScaleSetName "jumpvm"

# Remove customscrip
Remove-AzVmssExtension -VirtualMachineScaleSet $vmss -Name $extensionname
Update-AzVmss `
    -ResourceGroupName "JumpBox" `
    -Name "jumpvm" `
    -VirtualMachineScaleSet $vmss

 

$customConfigv2 = @{
    "fileUris"         = (, "https://raw.githubusercontent.com/lenvolk/AzVmssExtension/main/notepadv2.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File notepadv2.ps1"
}

Add-AzVmssExtension -VirtualMachineScaleSet $vmss `
    -Name $extensionname `
    -Publisher "Microsoft.Compute" `
    -Type "CustomScriptExtension" `
    -TypeHandlerVersion 1.10 `
    -Setting $customConfigv2

# Update the scale set and apply the Custom Script Extension to the VM instances
Update-AzVmss `
    -ResourceGroupName "JumpBox" `
    -Name "jumpvm" `
    -VirtualMachineScaleSet $vmss

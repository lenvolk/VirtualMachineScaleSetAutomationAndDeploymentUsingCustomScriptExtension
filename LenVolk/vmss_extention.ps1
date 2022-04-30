
# Install Notepad++ v7.8.8
$customConfig = @{
    "fileUris"         = (, "https://raw.githubusercontent.com/lenvolk/VirtualMachineScaleSetAutomationAndDeploymentUsingCustomScriptExtension/master/LenVolk/notepad788.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File notepad788.ps1"
}

$extensionname = "customScript"

# Get information about the scale set
$vmss = Get-AzVmss `
    -ResourceGroupName "myResourceGroup" `
    -VMScaleSetName "myScaleSet"

# Use Custom Script Extension to install custom extension
$vmss = Add-AzVmssExtension `
    -VirtualMachineScaleSet $vmss `
    -Name $extensionname `
    -Publisher "Microsoft.Compute" `
    -Type "CustomScriptExtension" `
    -TypeHandlerVersion 1.9 `
    -Setting $customConfig

# Update the scale set and apply the Custom Script Extension to the VM instances
Update-AzVmss `
    -ResourceGroupName "myResourceGroup" `
    -Name "myScaleSet" `
    -VirtualMachineScaleSet $vmss

#### !!! Update Notepad++ to v 8.2.1

$vmss = Get-AzVmss `
    -ResourceGroupName "myResourceGroup" `
    -VMScaleSetName "myScaleSet"

# Remove customscrip
Remove-AzVmssExtension -VirtualMachineScaleSet $vmss -Name $extensionname
Update-AzVmss `
    -ResourceGroupName "myResourceGroup" `
    -Name "myScaleSet" `
    -VirtualMachineScaleSet $vmss

 

$customConfigv2 = @{
    "fileUris"         = (, "https://raw.githubusercontent.com/lenvolk/VirtualMachineScaleSetAutomationAndDeploymentUsingCustomScriptExtension/master/LenVolk/notepad821.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File notepad821.ps1"
}

$vmss = Add-AzVmssExtension `
    -VirtualMachineScaleSet $vmss `
    -Name $extensionname `
    -Publisher "Microsoft.Compute" `
    -Type "CustomScriptExtension" `
    -TypeHandlerVersion 1.9 `
    -Setting $customConfigv2

# Update the scale set and apply the Custom Script Extension to the VM instances
Update-AzVmss `
    -ResourceGroupName "myResourceGroup" `
    -Name "myScaleSet" `
    -VirtualMachineScaleSet $vmss

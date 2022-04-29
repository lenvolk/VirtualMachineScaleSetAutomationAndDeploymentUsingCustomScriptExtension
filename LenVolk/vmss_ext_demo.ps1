# https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/tutorial-install-apps-powershell#update-app-deployment

$customConfig = @{
    "fileUris"         = (, "https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate-iis.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File automate-iis.ps1"
}

# Get information about the scale set
$vmss = Get-AzVmss `
    -ResourceGroupName "JumpBox" `
    -VMScaleSetName "web"

# Add the Custom Script Extension to install IIS and configure basic website
$vmss = Add-AzVmssExtension `
    -VirtualMachineScaleSet $vmss `
    -Name "customScript" `
    -Publisher "Microsoft.Compute" `
    -Type "CustomScriptExtension" `
    -TypeHandlerVersion 1.9 `
    -Setting $customConfig

# Update the scale set and apply the Custom Script Extension to the VM instances
Update-AzVmss `
    -ResourceGroupName "JumpBox" `
    -Name "web" `
    -VirtualMachineScaleSet $vmss


### Update 

$customConfigv2 = @{
    "fileUris"         = (, "https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate-iis-v2.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File automate-iis-v2.ps1"
}

$vmss = Get-AzVmss `
    -ResourceGroupName "JumpBox" `
    -VMScaleSetName "web"
 
$vmss.VirtualMachineProfile.ExtensionProfile[0].Extensions[0].Settings = $customConfigv2
 
Update-AzVmss `
    -ResourceGroupName "JumpBox" `
    -Name "web" `
    -VirtualMachineScaleSet $vmss
# step by step from example https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/tutorial-install-apps-powershell#update-app-deployment


$rgname = "vmLab-lod32098045"
$location = "westus"
$vmssname = "labVmss"
$vnetname = "vmssLabvNet"
$subnetname = "AppSubnet"
$pipname = "piplb"
$lbname = "labVmsslb"


New-AzVmss `
    -ResourceGroupName $rgname `
    -VMScaleSetName $vmssname `
    -Location $location `
    -VirtualNetworkName $vnetname `
    -SubnetName $subnetname `
    -PublicIpAddressName $pipname `
    -LoadBalancerName $lbname `
    -UpgradePolicyMode "Automatic"

# manually create web_nsg
# allow port 80 ingress rule
# reboot instances in the VMSS before continue


$customConfig = @{
    "fileUris"         = (, "https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate-iis.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File automate-iis.ps1"
}

# Get information about the scale set
$vmss = Get-AzVmss `
    -ResourceGroupName $rgname `
    -VMScaleSetName "$vmssname"

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
    -ResourceGroupName $rgname `
    -Name $vmssname`
    -VirtualMachineScaleSet $vmss


Get-AzPublicIpAddress -ResourceGroupName $rgname | Select IpAddress

# Now let's update the VMSS application

$customConfigv2 = @{
    "fileUris"         = (, "https://raw.githubusercontent.com/Azure-Samples/compute-automation-configurations/master/automate-iis-v2.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File automate-iis-v2.ps1"
}

$vmss = Get-AzVmss `
    -ResourceGroupName $rgname `
    -VMScaleSetName "$vmssname"
 
$vmss.VirtualMachineProfile.ExtensionProfile[0].Extensions[0].Settings = $customConfigv2
 
Update-AzVmss `
    -ResourceGroupName $rgname `
    -Name $vmssname`
    -VirtualMachineScaleSet $vmss

# Clean up
Remove-AzResourceGroup -Name $rgname -Force -AsJob
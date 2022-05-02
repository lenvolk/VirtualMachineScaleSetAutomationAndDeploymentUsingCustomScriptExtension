#Choose MAG
Connect-AzAccount -EnvironmentName AzureUSGovernment
# authenticate to the portal
Add-AzAccount
#Select the correct subscription
Get-AzSubscription -SubscriptionName "AzIntConsumption" | Select-AzSubscription


#### Logs
# C:\WindowsAzure\Logs\Plugins\Microsoft.Compute.CustomScriptExtension\1.9\CustomScriptHandler.txt
# 
# C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.10.12\Downloads\0
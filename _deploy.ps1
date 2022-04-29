#Choose MAG
Connect-AzAccount -EnvironmentName AzureUSGovernment
# authenticate to the portal
Add-AzAccount
#Select the correct subscription
Get-AzSubscription -SubscriptionName "AzIntConsumption" | Select-AzSubscription
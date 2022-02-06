#Name of VirualNetwork
$vnetName = "aac-vnet"
#Nameof Subnet
$subnetName= "aac-sn"
#Name of REsource Group
$RG = 'AzureAutomationTest-RG'

#splatt for vnet lookup
$net =@{
    Name = $vnetName
    ResourceGroupName = $RG
}

#fillvariable with vNet 
$vNet  = Get-AzVirtualNetwork @net

#Set required switch to disabled
($vnet | Select-Object -ExpandProperty subnets | Where-Object {$_.Name -eq $subnetName}).PrivateEndpointNetworkPolicies = "Disabled"

#commit the changes
$vNet | Set-AzVirtualNetwork


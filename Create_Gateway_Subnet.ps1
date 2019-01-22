param(

[Parameter(Mandatory=$True)]
[string] $vnet,

[Parameter(Mandatory=$True)]
[string] $ResourceGroup

)

$vnet = Get-AzureRmVirtualNetwork -Name $Vnet -ResourceGroupName $ResourceGroup

Add-AzureRmVirtualNetworkSubnetConfig -Name GatewaySubnet -VirtualNetwork $vnet -AddressPrefix 10.10.2.0/24

$vnet = Set-AzureRmVirtualNetwork -VirtualNetwork $vnet
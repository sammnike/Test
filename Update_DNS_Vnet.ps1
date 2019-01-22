param(

[Parameter(Mandatory=$True)]
[string] $resourceGroup,

[Parameter(Mandatory=$True)]
[string] $VnetName,

[Parameter(Mandatory=$True)]
[string] $NICName

)

$vnet = Get-AzureRmVirtualNetwork -ResourceGroupName $resourceGroup -name $VnetName
$NIC = Get-AzureRmNetworkInterface -ResourceGroupName $ResourceGroup -Name $NICName
$DNSIP =(Get-AzureRmNetworkInterfaceIpConfig -NetworkInterface $NIC).PrivateIpAddress
$vnet.DhcpOptions.DnsServers = $DNSIP
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet
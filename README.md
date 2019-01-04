# Create and configure a Windows Virtual Machine with Resource Manager and Azure PowerShell
# run command giving following parameters:
# CreateAzureVM.ps1 -vmname "MyVMNameHereâ€ -vmsize â€œMyVMSizeHereâ€ -nicName "MyNICNameHere" -subscr â€œMySubsNameHereâ€ 

# optionally you can delete this param clause (line 6) and give predefined variable values below
param ($vmName, $vmSize, $nicName, $subscr)

Login-AzureRmAccount

# $subscr = "Free_Trial"
# $vmName="TestVm_X"
# $vmSize="Standard_A1"
# $nicName="vmNIC"
$rgName = "vm_resource_group"
$locName = "North Europe"
$saName="jukkatpmvmstorage"
$saType="Standard_LRS"
$vnetName="TestNet"
$subnetIndex=0

Select-AzureRmSubscription -SubscriptionName $subscr

New-AzureRmResourceGroup -Name $rgName -Location $locName

New-AzureRmStorageAccount -Name $saName -ResourceGroupName $rgName â€“Type $saType -Location $locName

$subnet=New-AzureRmVirtualNetworkSubnetConfig -Name Subnet -AddressPrefix 10.0.1.0/24
New-AzureRmVirtualNetwork -Name TestNet -ResourceGroupName $rgName -Location $locName -AddressPrefix 10.0.0.0/16 -Subnet $subnet

$vnet=Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName

$pip = New-AzureRmPublicIpAddress -Name $nicName -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[$subnetIndex].Id -PublicIpAddressId $pip.Id

# create a local VM object

$vm=New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize

$pubName="MicrosoftWindowsServer"
$offerName="WindowsServer"
$skuName="2012-R2-Datacenter"
$cred=Get-Credential -Message "Type the name and password of the local administrator account for the new VM:"
$vm=Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $vmName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm=Set-AzureRmVMSourceImage -VM $vm -PublisherName $pubName -Offer $offerName -Skus $skuName -Version "latest"
$vm=Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id

$diskName="OSDisk"
$storageAcc=Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $saName
$osDiskUri=$storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/" + $diskName  + ".vhd"
$vm=Set-AzureRmVMOSDisk -VM $vm -Name $diskName -VhdUri $osDiskUri -CreateOption fromImage
New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm

# Status information fetch, this part of script is not fully working
#$vm = Get-AzureVM -ResourceGroupName $rgName -Name $vmName -Status
#$vmStatus = $vm.Statuses
# if (!($vm.Statuses -eq "Running")) {   
#    do {   
#        Write-host "Waiting for" $vmName " to have a 'Running' status ...." $vmStatus    
#        Start-Sleep -s 5    #Wait 5 seconds   
#        #Check the status   
#        $vm = Get-AzureVM -ResourceGroupName $rgName -Name $vmName -Status
#        $vmStatus = $vm.Statuses  
#      }until($vmStatus -eq "Started")   
#    }   
#     Write-host $vmName "is" $vmStatus   -ForegroundColor Green

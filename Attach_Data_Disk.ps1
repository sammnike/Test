param(

[Parameter(Mandatory=$True)]
[string] $rgName,

[Parameter(Mandatory=$True)]
[string] $vmName,

[Parameter(Mandatory=$True)]
[string] $storageType,

[Parameter(Mandatory=$True)]
[string] $dataDiskName,

[Parameter(Mandatory=$True)]
[string] $dataDiskSize,

[Parameter(Mandatory=$True)]
[string] $Lun,

[Parameter(Mandatory=$True)]
[string] $location
)

$diskConfig = New-AzureRmDiskConfig -SkuName $storageType -Location $location -CreateOption Empty -DiskSizeGB $dataDiskSize
$dataDisk1 = New-AzureRmDisk -DiskName $dataDiskName -Disk $diskConfig -ResourceGroupName $rgName

$vm = Get-AzureRmVM -Name $vmName -ResourceGroupName $rgName 
$vm = Add-AzureRmVMDataDisk -VM $vm -Name $dataDiskName -CreateOption Attach -ManagedDiskId $dataDisk1.Id -Lun $Lun -StorageAccountType $storageType

Update-AzureRmVM -VM $vm -ResourceGroupName $rgName
param(

[Parameter(Mandatory=$True)]
[string] $rgname,

[Parameter(Mandatory=$True)]
[string] $vmName,

[Parameter(Mandatory=$True)]
[string] $keyEncryptionKeyName,

[Parameter(Mandatory=$True)]
[string] $KeyVaultName

)

$KeyVault = Get-AzureRmKeyVault -VaultName $KeyVaultName -ResourceGroupName $rgname;
$diskEncryptionKeyVaultUrl = $KeyVault.VaultUri;
$KeyVaultResourceId = $KeyVault.ResourceId;
$keyEncryptionKeyUrl = (Get-AzureKeyVaultKey -VaultName $KeyVaultName -Name $keyEncryptionKeyName).Id;

Set-AzureRmVMDiskEncryptionExtension -ResourceGroupName $rgname -VMName $vmName `
-DiskEncryptionKeyVaultUrl $diskEncryptionKeyVaultUrl -DiskEncryptionKeyVaultId $KeyVaultResourceId `
-KeyEncryptionKeyUrl $keyEncryptionKeyUrl -KeyEncryptionKeyVaultId $KeyVaultResourceId -VolumeType All -Force;
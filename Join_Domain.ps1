param(

[Parameter(Mandatory=$True)]
[string] $resourceGroup,

[Parameter(Mandatory=$True)]
[string] $vmName,

[Parameter(Mandatory=$True)]
[string] $password,

[Parameter(Mandatory=$True)]
[string] $location
)



$string1 = '{
    "Name" = "shadab.local",
    "User" = "shadab.local\\john.doe",
    "Restart" = "true",
    "Options" = "3"
    }'
$string2 = '{"Password": $password }'

Set-AzureRmVMExtension -ResourceGroupName $resourceGroup -ExtensionType "JsonADDomainExtension" -Name "joindomain" `
-Publisher "Microsoft.Compute" -TypeHandlerVersion "1.0" `
-VMName $vmName -Location $location -SettingString $string1 -ProtectedSettingString $string2
param(

[Parameter(Mandatory=$True)]
[string] $resourceGroup,

[Parameter(Mandatory=$True)]
[string] $vmName,

[Parameter(Mandatory=$True)]
[string] $location
)

$PublicSettings = '{"commandToExecute":"powershell Install-WindowsFeature Web-Server -IncludeManagementTools"}'

Set-AzureRmVMExtension -ExtensionName "IIS" -ResourceGroupName $resourceGroup -VMName $vmName `
  -Publisher "Microsoft.Compute" -ExtensionType "CustomScriptExtension" -TypeHandlerVersion 1.4 `
  -SettingString $PublicSettings -Location $location
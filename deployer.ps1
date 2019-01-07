param([string[]]$prefixList = @())
# usage -- deployer.ps1 -prefixList comma,separated,prefixes,keep,them,short

import-module Azure
Login-AzureRm;Account
Select-AzureRmSubscription -SubscriptionName "<INSERT YOUR SUBSCRIPTION NAME>"

$password = ConvertTo-SecureString -String "P@ssw0rd100100" -AsPlainText -Force

foreach($prefix in $prefixList) {
    $rgName = "rg-sql-$prefix"
    Write-Host Creating $rgName...
    New-AzureRmResourceGroup -Name $rgName -Location "East US 2"
    Write-Host Starting deployment to $rgName...
    
    New-AzureRmResourceGroupDeployment -Name "dep-$rgname" -ResourceGroupName $rgName -TemplateFile .\bobc-linux-win.template.json `
                                       -location "East US 2" -namePrefix $prefix -virtualMachineSize "Standard_D4s_v3" -adminUsername "sqluser" -adminPassword $password -Verbose
}

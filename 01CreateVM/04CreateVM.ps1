param(
    [string]$location = "australiasoutheast",
    [string]$myResourceGroup = "ExamPrepRG"
)

$myNICName = $myResourceGroup + "Nic"
$myVMNAme = $myResourceGroup + "VM"
$myStorageAccountName = "hect" + $myResourceGroup.ToLower()
$blobPath = "vhds/myOsDisk1.vhd"
$myStorageAccount = Get-AzureRmStorageAccount -Name $myStorageAccountName `
     -ResourceGroupName $myResourceGroup
$osDiskUri = $myStorageAccount.PrimaryEndpoints.Blob.ToString() + $blobPath
$myNIC = Get-AzureRmNetworkInterface -Name $myNICName -ResourceGroupName $myResourceGroup
$cred = Get-Credential

$myVMConfig = New-AzureRmVMConfig `
    -VMName $myVMNAme -VMSize "Standard_DS1_v2"
$myVMConfig = Set-AzureRmVMOperatingSystem `
    -vm $myVMConfig -Windows -ComputerName $myVMNAme -Credential $cred `
    -ProvisionVMAgent -EnableAutoUpdate
$myVMConfig = Set-AzureRmVMSourceImage `
    -VM $myVMConfig -PublisherName "MicrosoftWindowsServer" `
    -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version "latest"
$myVMConfig = Set-azureRMVMOSDisk `
    -VM $myVMConfig -Name "myOsDisk1" -VhdUri $osDiskUri `
    -CreateOption FromImage
$myVMConfig = Add-AzureRmVMNetworkInterface `
    -VM $myVMConfig -Id $myNIC.Id -Primary

Write-Host "Creating virtual machine $myVMNAme in resource group $myResourceGroup"
New-AzureRmVM -ResourceGroupName $myResourceGroup -Location $location `
    -VM $myVMConfig

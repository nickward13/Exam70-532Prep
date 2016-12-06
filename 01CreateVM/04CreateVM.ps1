param(
    [string]$location = "australiasoutheast",
    [string]$myResourceGroup = "ExamPrepRG",
    [string]$myVMNAme = "myVM",
    [string]$myStorageAccountName = "hectagonstorage23",
    [string]$myNICName = "myNIC"
)

$cred = Get-Credential
$myVMConfig = New-AzureRmVMConfig -VMName $myVMNAme -VMSize "Standard_DS1_v2"
$myVMConfig = Set-AzureRmVMOperatingSystem -vm $myVMConfig -Windows -ComputerName $myVMNAme -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$myVMConfig = Set-AzureRmVMSourceImage -VM $myVMConfig -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version "latest"
$myNIC = Get-AzureRmNetworkInterface -Name $myNICName -ResourceGroupName $myResourceGroup
$myVMConfig = Add-AzureRmVMNetworkInterface -VM $myVMConfig -Id $myNIC.Id
$blobPath = "vhds/myOsDisk1.vhd"
$myStorageAccount = Get-AzureRmStorageAccount -Name $myStorageAccountName -ResourceGroupName $myResourceGroup
$osDiskUri = $myStorageAccount.PrimaryEndpoints.Blob.ToString() + $blobPath
$myVMConfig = Set-azureRMVMOSDisk -VM $myVMConfig -Name "myOsDisk1" -VhdUri $osDiskUri -CreateOption FromImage

Write-Host "Creating virtual machine $myVMNAme in resource group $myResourceGroup"
New-AzureRmVM -ResourceGroupName $myResourceGroup -Location $location -VM $myVMConfig
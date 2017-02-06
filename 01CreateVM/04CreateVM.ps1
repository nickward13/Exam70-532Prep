param(
    [string]$location = "australiasoutheast",
    [string]$myResourceGroup = "ExamPrepRG"
)

$myStorageAccountName = "hect" + $myResourceGroup.ToLower()
$myStorageAccount = Get-AzureRmStorageAccount -Name $myStorageAccountName `
     -ResourceGroupName $myResourceGroup
$cred = Get-Credential

$myAS = New-AzureRmAvailabilitySet -ResourceGroupName $myResourceGroup -Name WebAS -Location $location

for ($i = 0; $i -lt 2; $i++) {
    $myNICName = $myResourceGroup + "WebNic" + $i
    $myVMNAme = "WebVM" + $i
    $blobPath = "vhds/" + $myVMName + "OsDisk.vhd"
    $osDiskUri = $myStorageAccount.PrimaryEndpoints.Blob.ToString() + $blobPath
    $osDiskName = "myOsDisk" + $i
    $myNIC = Get-AzureRmNetworkInterface -Name $myNICName -ResourceGroupName $myResourceGroup

    $myVMConfig = New-AzureRmVMConfig `
        -VMName $myVMNAme -VMSize "Standard_DS1_v2" -AvailabilitySetId $myAS.Id
    $myVMConfig = Set-AzureRmVMOperatingSystem `
        -vm $myVMConfig -Windows -ComputerName $myVMNAme -Credential $cred `
        -ProvisionVMAgent -EnableAutoUpdate
    $myVMConfig = Set-AzureRmVMSourceImage `
        -VM $myVMConfig -PublisherName "MicrosoftWindowsServer" `
        -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version "latest"
    $myVMConfig = Set-azureRMVMOSDisk `
        -VM $myVMConfig -Name $osDiskName -VhdUri $osDiskUri `
        -CreateOption FromImage
    $myVMConfig = Add-AzureRmVMNetworkInterface `
        -VM $myVMConfig -Id $myNIC.Id -Primary
    Write-Host "Creating virtual machine $myVMNAme in resource group $myResourceGroup"
    New-AzureRmVM -ResourceGroupName $myResourceGroup -Location $location `
        -VM $myVMConfig
    
}

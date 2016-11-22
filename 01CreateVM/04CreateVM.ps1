$cred = Get-Credential
$myVMConfig = New-AzureRmVMConfig -VMName "myVM" -VMSize "Standard_DS1_v2"
$myVMConfig = Set-AzureRmVMOperatingSystem -vm $myVMConfig -Windows -ComputerName "myVM" -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$myVMConfig = Set-AzureRmVMSourceImage -VM $myVMConfig -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2012-R2-Datacenter" -Version "latest"
$myVMConfig = Add-AzureRmVMNetworkInterface -VM $myVMConfig -Id $myNIC.Id
$blobPath = "vhds/myOsDisk1.vhd"
$osDiskUri = $myStorageAccount.PrimaryEndpoints.Blob.ToString() + $blobPath
$myVMConfig = Set-azureRMVMOSDisk -VM $myVMConfig -Name "myOsDisk1" -VhdUri $osDiskUri -CreateOption FromImage
New-AzureRmVM -ResourceGroupName $myResourceGroup -Location $location -VM $myVMConfig
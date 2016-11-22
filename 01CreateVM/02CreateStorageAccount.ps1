$myStorageAccountName = "hectagonstorage23"
Get-AzureRMStorageACcountNameAvailability -Name $myStorageAccountName
$myStorageAccount = NewAzureRMStorageAccount -ResourceGroupName $myResourceGroup -Name $myStorageAccountName -SkuName "Standard_LRS" -Kind "Storage" -Location $location

param(
    [string]$location = "australiasoutheast",
    [string]$myResourceGroup = "myResourceGroup",
    [string]$myStorageAccountName = "hectagonstorage23"
)

Get-AzureRMStorageACcountNameAvailability -Name $myStorageAccountName
Write-Host "Creating storage account '$myStorageAccountName' in resource group '$myResourceGroup'"
$myStorageAccount = New-AzureRMStorageAccount -ResourceGroupName $myResourceGroup -Name $myStorageAccountName -SkuName "Standard_LRS" -Kind "Storage" -Location $location

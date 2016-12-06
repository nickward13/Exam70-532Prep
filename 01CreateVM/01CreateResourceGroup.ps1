param(
    [string]$location = "australiasoutheast",
    [string]$myResourceGroup = "ExamPrepRG"
)

Write-Host "Creating resource group $myResourceGroup in $location..."
New-AzureRMResourceGroup -Name $myResourceGroup -Location $location

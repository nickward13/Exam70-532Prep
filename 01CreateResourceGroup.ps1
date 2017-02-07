param(
    [string]$myResourceGroup = "ExamPrepRG",
    [string]$location = "australiasoutheast"
)

Write-Host "Creating resource group $myResourceGroup in $location..."
New-AzureRMResourceGroup -Name $myResourceGroup -Location $location
.\00CreateVNET\01CreateVNET.ps1

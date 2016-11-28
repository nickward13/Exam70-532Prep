param(
    [string]$myResourceGroup = "myResourceGroup"
)
Remove-AzureRmResourceGroup -Name $myResourceGroup -Force

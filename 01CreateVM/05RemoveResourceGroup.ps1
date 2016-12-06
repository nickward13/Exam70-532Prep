param(
    [string]$myResourceGroup = "ExamPrepRG"
)
Remove-AzureRmResourceGroup -Name $myResourceGroup -Force

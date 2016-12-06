param(
    [string]$myResourceGroup = "ExamPrepRG"
)
.\01CreateResourceGroup.ps1 -myResourceGroup $myResourceGroup
.\02CreateStorageAccount.ps1 -myResourceGroup $myResourceGroup
.\03CreateVNET.ps1 -myResourceGroup $myResourceGroup
.\04CreateVM.ps1 -myResourceGroup $myResourceGroup

param(
    [string]$myResourceGroup = "ExamPrepRG"
)
.\01CreateVM\01CreateNetworkInterface.ps1
.\01CreateVM\02CreateStorageAccount.ps1
.\01CreateVM\04CreateVM.ps1

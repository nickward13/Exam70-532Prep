param(
    [string]$ResourceGroupName = "ExamPrepRG"
)

$StorageAccountName = "hect" + $ResourceGroupName.ToLower()

$StorageAccountKey = Get-AzureRmStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName

.\UploadScriptToStorage\UploadScriptToStorage\bin\release\UploadScriptToStorage.exe $StorageAccountName $StorageAccountKey[0].Value

param(
    [string]$ResourceGroupName = "ExamPrepRG",
    [string]$VMName = "myVM",
    [string]$ConfigurationName = "IisInstall",
    [string]$StorageAccountName = "hectagonstorage23"
)

#Publish the configuration script to user storage
Write-Host "Publishing configuration script '$ConfigurationPath' to '$StorageAccountName'"
$ConfigurationPath = ".\" + $ConfigurationName + ".ps1"
Publish-AzureRmVMDscConfiguration -ResourceGroupName $ResourceGroupName -ConfigurationPath $ConfigurationPath -ContainerName "config" -StorageAccountName $StorageAccountName -Verbose -Force

# Set the VM to run the DSC configuration
$ArchiveBlobName = $ConfigurationName + ".ps1.zip"
Write-Host "Setting DSC Extension from $ArchiveBlobName on VM $VMName"
Set-AzureRmVMDscExtension -ResourceGroupName $ResourceGroupName -VMName $VMName -ArchiveBlobName $ArchiveBlobName -ArchiveStorageAccountName $StorageAccountName -ArchiveContainerName "config" -Version "2.20" -Verbose -ConfigurationName "IISInstall"

# Check DSC Status
Get-AzureRmVMDscExtension -ResourceGroupName $ResourceGroupName -VMName $VMName -Verbose



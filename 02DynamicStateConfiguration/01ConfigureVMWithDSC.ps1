param(
    [string]$ResourceGroupName = "ExamPrepRG"
)
$ConfigurationName = "IisInstall"
$StorageAccountName = "hect" + $ResourceGroupName.ToLower()

#Publish the configuration script to user storage
$ConfigurationPath = ".\" + $ConfigurationName + ".ps1"
Write-Host "Publishing configuration script '$ConfigurationPath' to '$StorageAccountName'"
Publish-AzureRmVMDscConfiguration -ResourceGroupName $ResourceGroupName `
    -ConfigurationPath $ConfigurationPath -ContainerName "config" `
    -StorageAccountName $StorageAccountName -Verbose -Force

# Set the VM to run the DSC configuration
$ArchiveBlobName = $ConfigurationName + ".ps1.zip"

for ($i = 0; $i -lt 2; $i++) {
    $VMName = "WebVM" + $i
    Write-Host "Setting DSC Extension from $ArchiveBlobName on VM $VMName"
    Set-AzureRmVMDscExtension -ResourceGroupName $ResourceGroupName `
        -VMName $VMName -ArchiveBlobName $ArchiveBlobName `
        -ArchiveStorageAccountName $StorageAccountName `
        -ArchiveContainerName "config" -Version "2.20" `
        -Verbose -ConfigurationName "IISInstall"

    # Check DSC Status
    Get-AzureRmVMDscExtension -ResourceGroupName $ResourceGroupName `
        -VMName $VMName -Verbose
    
}

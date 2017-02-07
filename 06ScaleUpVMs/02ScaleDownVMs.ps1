param(
    [string]$myResourceGroup = "ExamPrepRG"
)

for( $i=0; $i -lt 2; $i++)
{
    $vmname = "WebVM" + $i
    $vm = Get-AzureRmVM -ResourceGroupName $myResourceGroup -Name $vmname
    $vm.HardwareProfile.VmSize = "Standard_DS1_v2"
    Update-AzureRmVM -VM $vm -ResourceGroupName $myResourceGroup
}

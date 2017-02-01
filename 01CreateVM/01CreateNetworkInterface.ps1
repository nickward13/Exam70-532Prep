param(
    [string]$location = "australiasoutheast",
    [string]$myResourceGroup = "ExamPrepRG"
)

$myPublicIpName = $myResourceGroup + "PublicIp"
Write-Host "Creating public IP '$myPublicIpName'"
$myPublicIp = New-AzureRmPublicIpAddress -Name $myPublicIpName -ResourceGroupName $myResourceGroup -Location $location -AllocationMethod Dynamic

$myNICName = $myResourceGroup + "Nic"
Write-Host "Creating NIC '$myNICName'"
$myVnetName = $myResourceGroup + "Vnet"
$myVnet = Get-AzureRmVirtualNetwork -Name $myVnetName -ResourceGroupName $myResourceGroup
$myNIC = New-AzureRmNetworkInterface -Name $myNICName -ResourceGroupName $myResourceGroup -Location $location -SubnetId $myVnet.Subnets[0].Id -PublicIpAddressId $myPublicIp.Id

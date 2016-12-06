param(
    [string]$location = "australiasoutheast",
    [string]$myResourceGroup = "ExamPrepRG"
)
$mySubnetName = $myResourceGroup + "Subnet"
Write-Host "Creating subnet '$mySubnetName'"
$mySubnet = New-AzureRmVirtualNetworkSubnetConfig -Name $mySubnetName -AddressPrefix 10.0.0.0/24

$myVnetName = $myResourceGroup + "Vnet"
Write-Host "Creating Virtual Network '$myVnetName'"
$myVnet = New-AzureRmVirtualNetwork -Name $myVnetName -ResourceGroupName $myResourceGroup -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $mySubnet

$myPublicIpName = $myResourceGroup + "PublicIp"
Write-Host "Creating public IP '$myPublicIpName'"
$myPublicIp = New-AzureRmPublicIpAddress -Name $myPublicIpName -ResourceGroupName $myResourceGroup -Location $location -AllocationMethod Dynamic

$myNICName = $myResourceGroup + "Nic"
Write-Host "Creating NIC '$myNICName'"
$myNIC = New-AzureRmNetworkInterface -Name $myNICName -ResourceGroupName $myResourceGroup -Location $location -SubnetId $myVnet.Subnets[0].Id -PublicIpAddressId $myPublicIp.Id

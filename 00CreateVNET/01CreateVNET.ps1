param(
    [string]$location = "australiasoutheast",
    [string]$myResourceGroup = "ExamPrepRG"
)

$myVnetName = $myResourceGroup + "Vnet"
$myVnet = New-AzureRmVirtualNetwork -Name $myVnetName -ResourceGroupName $myResourceGroup -Location $location -AddressPrefix 10.0.0.0/8

$mySubnetName = $myResourceGroup + "Subnet"
Add-AzureRmVirtualNetworkSubnetConfig -Name $mySubnetName -VirtualNetwork $myVnet -AddressPrefix 10.0.0.0/24
Add-AzureRmVirtualNetworkSubnetConfig -Name FrontEnd -VirtualNetwork $myVnet -AddressPrefix 10.0.1.0/24
Add-AzureRmVirtualNetworkSubnetConfig -Name BackEnd -VirtualNetwork $myVnet -AddressPrefix 10.0.2.0/24

Set-AzureRmVirtualNetwork $myVnet

$myPublicIpName = $myResourceGroup + "PublicIp"
Write-Host "Creating public IP '$myPublicIpName'"
$myPublicIp = New-AzureRmPublicIpAddress -Name $myPublicIpName -ResourceGroupName $myResourceGroup -Location $location -AllocationMethod Dynamic

$myNICName = $myResourceGroup + "Nic"
Write-Host "Creating NIC '$myNICName'"
$myNIC = New-AzureRmNetworkInterface -Name $myNICName -ResourceGroupName $myResourceGroup -Location $location -SubnetId $myVnet.Subnets[0].Id -PublicIpAddressId $myPublicIp.Id

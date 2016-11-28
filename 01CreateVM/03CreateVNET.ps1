param(
    [string]$location = "australiasoutheast",
    [string]$myResourceGroup = "myResourceGroup",
    [string]$mySubnetName = "mySubnet",
    [string]$myVnetName = "myVnet",
    [string]$myPublicIpName = "myPublicIP",
    [string]$myNICName = "myNIC"
)

Write-Host "Creating subnet '$mySubnetName'"
$mySubnet = New-AzureRmVirtualNetworkSubnetConfig -Name $mySubnetName -AddressPrefix 10.0.0.0/24

Write-Host "Creating Virtual Network '$myVnetName'"
$myVnet = New-AzureRmVirtualNetwork -Name $myVnetName -ResourceGroupName $myResourceGroup -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $mySubnet

Write-Host "Creating public IP '$myPublicIpName'"
$myPublicIp = New-AzureRmPublicIpAddress -Name $myPublicIpName -ResourceGroupName $myResourceGroup -Location $location -AllocationMethod Dynamic

Write-Host "Creating NIC '$myNICName'"
$myNIC = New-AzureRmNetworkInterface -Name $myNICName -ResourceGroupName $myResourceGroup -Location $location -SubnetId $myVnet.Subnets[0].Id -PublicIpAddressId $myPublicIp.Id

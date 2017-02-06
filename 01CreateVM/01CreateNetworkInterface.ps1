param(
    [string]$location = "australiasoutheast",
    [string]$myResourceGroup = "ExamPrepRG"
)


$myVnetName = $myResourceGroup + "Vnet"
$myVnet = Get-AzureRmVirtualNetwork -Name $myVnetName -ResourceGroupName $myResourceGroup

for ($i = 0; $i -lt 2; $i++) {
    $myPublicIpName = $myResourceGroup + "PublicIp" + $i
    Write-Host "Creating public IP '$myPublicIpName'"
    $myPublicIp = New-AzureRmPublicIpAddress -Name $myPublicIpName -ResourceGroupName $myResourceGroup -Location $location -AllocationMethod Dynamic

    $myNICName = $myResourceGroup + "WebNic" + $i
    Write-Host "Creating NIC '$myNICName'"
    $myNIC = New-AzureRmNetworkInterface -Name $myNICName -ResourceGroupName $myResourceGroup -Location $location -SubnetId $myVnet.Subnets[0].Id -PublicIpAddressId $myPublicIp.Id
    
}


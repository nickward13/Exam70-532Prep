param(
    [string]$location = "australiasoutheast",
    [string]$myResourceGroup = "ExamPrepRG"
)

# Create allow RDP rule for Front End subnet
$rule1 = New-AzureRmNetworkSecurityRuleConfig -Name rdp-rule `
    -Description "Allow RDP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 `
    -SourceAddressPrefix Internet -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 3389

# Create allow Internet traffic to port 80 rule for Front End subnet
$rule2 = New-AzureRmNetworkSecurityRuleConfig -Name web-rule `
    -Description "Allow HTTP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 101 `
    -SourceAddressPrefix Internet -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 80

# Create deny outbound Internet traffic rule for Front End subnet
$rule3 = New-AzureRmNetworkSecurityRuleConfig -Name outbound-web-rule `
    -Description "Deny outbound Internet" `
    -Access Deny -Protocol * -Direction Outbound -Priority 200 `
    -SourceAddressPrefix * -SourcePortRange * `
    -DestinationAddressPrefix Internet -DestinationPortRange *

# Create NSG with three rules
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $myResourceGroup `
    -Location $location `
    -Name "NSG-FrontEnd" -SecurityRules $rule1, $rule2, $rule3

$vnetName = $myResourceGroup + "Vnet"
$vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $myResourceGroup
Set-AzureRmVirtualNetworkSubnetConfig -Name "FrontEnd" `
    -VirtualNetwork $vnet -AddressPrefix "10.0.1.0/24" `
    -NetworkSecurityGroup $nsg
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet

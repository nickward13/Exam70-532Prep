param(
    [string]$location = "australiasoutheast",
    [string]$myResourceGroup = "ExamPrepRG"
)

Write-Host "Creating public IP address..."
$publicIPAddress = New-AzureRmPublicIpAddress -ResourceGroupName $myResourceGroup -Location $location `
    -Name "ExternalLBIPAddress" -AllocationMethod Dynamic `
    -IpAddressVersion IPv4 -DomainNameLabel "hectagonelb"

 $frontendIP = New-AzureRmLoadBalancerFrontendIpConfig -Name LB-Frontend -PublicIpAddress $publicIPAddress
 $beaddresspool = New-AzureRmLoadBalancerBackendAddressPoolConfig -Name LB-backend
 $lbrule = New-AzureRmLoadBalancerRuleConfig -Name HTTP -FrontendIpConfiguration $frontendIP -BackendAddressPool  $beAddressPool -Probe $healthProbe -Protocol Tcp -FrontendPort 80 -BackendPort 80
 $healthProbe = New-AzureRmLoadBalancerProbeConfig -Name HealthProbe -Protocol Tcp -Port 80 -IntervalInSeconds 15 -ProbeCount 2

Write-Host "Creating load balancer..."
 $NRPLB = New-AzureRmLoadBalancer -ResourceGroupName $myResourceGroup -Name ExternalLB -Location $location -FrontendIpConfiguration $frontendIP `
    -BackendAddressPool $beAddressPool -LoadBalancingRule $lbrule -Probe $healthProbe

$beaddresspool = Get-AzureRmLoadBalancerBackendAddressPoolConfig -Name LB-backend -LoadBalancer $NRPLB

for ($i = 0; $i -lt 2; $i++) {
    $myNICName = $myResourceGroup + "WebNic" + $i
    $myNIC = Get-AzureRmNetworkInterface -Name $myNICName -ResourceGroupName $myResourceGroup
    $myNIC.IpConfigurations[0].LoadBalancerBackendAddressPools=$beaddresspool
    Write-Host "Assigning backend address pool to NIC"
    Set-AzureRmNetworkInterface -NetworkInterface $myNIC
}
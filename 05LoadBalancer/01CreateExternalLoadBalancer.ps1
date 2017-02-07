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
 $healthProbe = New-AzureRmLoadBalancerProbeConfig -Name HealthProbe -Protocol Tcp -Port 80 -IntervalInSeconds 15 -ProbeCount 2
 $lbrule = New-AzureRmLoadBalancerRuleConfig -Name HTTP -FrontendIpConfiguration $frontendIP -BackendAddressPool  $beAddressPool -Probe $healthProbe -Protocol Tcp -FrontendPort 80 -BackendPort 80
 
$frontendpoolrangestart = 3360
$frontendpoolrangeend = 3370
$backendvmport = 3389
$inboundNatPool = New-AzureRmLoadBalancerInboundNatPoolConfig -Name IBNP -FrontendIPConfigurationId $frontendIP.Id -Protocol Tcp -FrontendPortRangeStart $frontendpoolrangestart -FrontendPortRangeEnd $frontendpoolrangeend -BackendPort $backendvmport

Write-Host "Creating load balancer..."
 $NRPLB = New-AzureRmLoadBalancer -ResourceGroupName $myResourceGroup -Name ExternalLB -Location $location -FrontendIpConfiguration $frontendIP -BackendAddressPool $beAddressPool -LoadBalancingRule $lbrule -Probe $healthProbe -InboundNatPool $inboundNatPool


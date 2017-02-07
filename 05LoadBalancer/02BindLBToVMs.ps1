param(
    [string]$rgname = "ExamPrepRG"
)

$lb = Get-AzureRmLoadBalancer -Name ExternalLB -ResourceGroupName $rgname

$beaddresspool = Get-AzureRmLoadBalancerBackendAddressPoolConfig -Name LB-backend -LoadBalancer $lb

for ($i = 0; $i -lt 2; $i++) {
    $myNICName = $myResourceGroup + "WebNic" + $i
    $myNIC = Get-AzureRmNetworkInterface -Name $myNICName -ResourceGroupName $myResourceGroup
    $myNIC.IpConfigurations[0].LoadBalancerBackendAddressPools=$beaddresspool
    Write-Host "Assigning backend address pool to NIC"
    Set-AzureRmNetworkInterface -NetworkInterface $myNIC
}
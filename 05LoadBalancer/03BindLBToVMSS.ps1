param(
    [string]$rgname = "ExamPrepRG",
    [string]$loc = "Australia Southeast"
)

$actualLb = Get-AzureRmLoadBalancer -Name ExternalLB -ResourceGroupName $rgname

$vnetname = $rgname + "Vnet"
$vnet = Get-AzureRmVirtualNetwork -Name $vnetname -ResourceGroupName $rgname
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name FrontEnd -VirtualNetwork $vnet

#specify VMSS Name
$vmssName = 'vmss' + $rgname.ToLower();

##specify VMSS specific details
$adminUsername = 'azadmin';
$adminPassword = "Password1234!";

$PublisherName = 'MicrosoftWindowsServer'
$Offer         = 'WindowsServer'
$Sku          = '2012-R2-Datacenter'
$Version       = 'latest'
$vmNamePrefix = 'winvmss'

$vhdContainer = "https://hectexampreprg.blob.core.windows.net/" + $vmssName;

###add an extension
$extname = 'BGInfo';
$publisher = 'Microsoft.Compute';
$exttype = 'BGInfo';
$extver = '2.1';

$ipCfg = New-AzureRmVmssIPConfig -Name 'nic' -LoadBalancerInboundNatPoolsId $actualLb.InboundNatPools[0].Id -LoadBalancerBackendAddressPoolsId $actualLb.BackendAddressPools[0].Id -SubnetId $subnet.Id;

#Specify number of nodes
$numberofnodes = 3

$vmss = New-AzureRmVmssConfig -Location $loc -SkuCapacity $numberofnodes -SkuName 'Standard_A2' -UpgradePolicyMode 'automatic' `
    | Add-AzureRmVmssNetworkInterfaceConfiguration -Name $subnet.Name -Primary $true -IPConfiguration $ipCfg `
    | Set-AzureRmVmssOSProfile -ComputerNamePrefix $vmNamePrefix -AdminUsername $adminUsername -AdminPassword $adminPassword `
    | Set-AzureRmVmssStorageProfile -Name 'test' -OsDiskCreateOption 'FromImage' -OsDiskCaching 'None' `
    -ImageReferenceOffer $Offer -ImageReferenceSku $Sku -ImageReferenceVersion $Version `
    -ImageReferencePublisher $PublisherName -VhdContainer $vhdContainer `
    | Add-AzureRmVmssExtension -Name $extname -Publisher $publisher -Type $exttype -TypeHandlerVersion $extver -AutoUpgradeMinorVersion $true

New-AzureRmVmss -ResourceGroupName $rgname -Name $vmssName -VirtualMachineScaleSet $vmss -Verbose;
param(
    [string]$ResourceGroupName="ExamPrepRG"
)

$parameters = @{"resourceGroupName" = $ResourceGroupName}

# deploy the template to the resource group
New-AzureRmResourceGroupDeployment -Name "ExampleDeployment" -ResourceGroupName $ResourceGroupName -TemplateFile template.json
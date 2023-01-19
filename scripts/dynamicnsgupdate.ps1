# Variables
$IP = (Invoke-WebRequest -uri "https://api.ipify.org/").Content

Function  AzureRuleUpdate {

    # Get current IP of the rule
    $RULEIP = (Get-AzNetworkSecurityGroup -Name $ENV:NSG_NAME | Get-AzNetworkSecurityRuleConfig -Name $ENV:RULE_NAME).SourceAddressPrefix # Change these
    
    # Compare current rule source IP with your current wan IP
    if ($RULEIP -ne $IP) {
        # Get NSG
        $nsg = Get-AzNetworkSecurityGroup -Name $ENV:NSG_NAME
        $nsg | Get-AzNetworkSecurityRuleConfig -Name $ENV:RULE_NAME
        
        # Get required variables
        $ruleprotocol = ($nsg | Get-AzNetworkSecurityRuleConfig -Name $ENV:RULE_NAME).Protocol
        $rulesourceportrange = ($nsg | Get-AzNetworkSecurityRuleConfig -Name $ENV:RULE_NAME).SourcePortRange
        $ruleDestinationPortRange = ($nsg | Get-AzNetworkSecurityRuleConfig -Name $ENV:RULE_NAME).DestinationPortRange
        $ruleDestinationAddressPrefix = ($nsg | Get-AzNetworkSecurityRuleConfig -Name $ENV:RULE_NAME).DestinationAddressPrefix
        $ruleAccess = ($nsg | Get-AzNetworkSecurityRuleConfig -Name $ENV:RULE_NAME).Access
        $rulePriority = ($nsg | Get-AzNetworkSecurityRuleConfig -Name $ENV:RULE_NAME).Priority
        $ruleDirection = ($nsg | Get-AzNetworkSecurityRuleConfig -Name $ENV:RULE_NAME).Direction
        
        # Update the rule
        Set-AzNetworkSecurityRuleConfig `
            -Access $ruleAccess `
            -Name $ENV:RULE_NAME `
            -SourceAddressPrefix $IP `
            -DestinationAddressPrefix $ruleDestinationAddressPrefix `
            -DestinationPortRange $ruleDestinationPortRange `
            -Direction $ruleDirection `
            -NetworkSecurityGroup $nsg `
            -Priority $rulePriority `
            -Protocol $ruleprotocol `
            -SourcePortRange $rulesourceportrange
        
        # Save the rule.
        $nsg | Set-AzNetworkSecurityGroup
    }
}

# Tenant login
$PASSWORD = $ENV:CERTIFICATE_PWD | ConvertTo-SecureString -AsPlainText -Force
Connect-AzAccount -ServicePrincipal -ApplicationId $ENV:APPLICATION_ID -TenantId $ENV:TENANT_ID -Subscription $ENV:SUBSCRIPTION_ID -CertificatePath "/app/certificate.pfx" -CertificatePassword $PASSWORD

# Update rule
AzureRuleUpdate
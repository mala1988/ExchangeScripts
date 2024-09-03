function Get-NonDefaultExchangeSecurityGroup {
    [CmdletBinding()]
    param (
        
    )
    
    $defaultSecurityGroups = (
        'Compliance Management',
        'Delegated Setup',
        'Discovery Management',
        'Exchange Servers',
        'Exchange Trusted Subsystem',
        'Exchange Windows Permissions',
        'ExchangeLegacyInterop',
        'Help Desk',
        'Hygiene Management',
        'Managed Availability Servers',
        'Organization Management',
        'Public Folder Management',
        'Recipient Management',
        'Records Management',
        'Security Administrator',
        'Security Reader',
        'Server Management',
        'UM Management',
        'View-Only Organization Management'
    )

    Get-ADGroup -Filter * -SearchBase 'OU=Microsoft Exchange Security Groups,DC=lan,DC=equitynova,DC=swiss' | Where-Object { $_.Name -notin $defaultSecurityGroups } | Sort-Object Name

}

$additionalExchangeSecurityGroups = $null
$additionalExchangeSecurityGroups = Get-NonDefaultExchangeSecurityGroup



foreach ($currentItemName in $additionalExchangeSecurityGroups) {
    Write-Output $currentItemName.Name
    
    $groupMember = Get-ADGroupMember -Identity $currentItemName

    if ($groupMember -ne $null) {
        $groupMember | Format-Table Name, SamAccountName 
    } else {
        Write-Output ''
        Write-Output 'This group holds no members'
        Write-Output ''
    }
}

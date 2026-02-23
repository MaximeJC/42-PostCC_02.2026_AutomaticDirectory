# ----------------------------------------------------------------
#
#                 CreateNewForestDomainController.ps1
#
# ----------------------------------------------------------------

using assembly System.Management.Automation
using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"

Import-Module ADDSDeployment

## Get domain name and netbios name

$prg_name = "JoinExistingForest"
$argsData = @(
    [Argument]::new("Domain name", $true, "domolia.lan")
)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()

    $DomainName = $form.getFormValue("Domain name")
}
catch {
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1)
}

###########################################################################
# During the evaluation, depending on the machine,
# we could have to re-generate the secure string with these commands
###########################################################################

# mkdir \secure
# $secure = Read-Host "Enter password" -AsSecureString
# $secure | ConvertFrom-SecureString | Out-File "C:\secure\pwd.txt"

$encrypted = Get-Content "C:\secure\pwd.txt"
$secureString = ConvertTo-SecureString $encrypted

$credentials = New-Object System.Management.Automation.PSCredential ("administrator@domolia.lan", $secureString)

## Test-ADDSForestInstallation
Try {
    $result = Test-ADDSDomainControllerInstallation -DomainName $DomainName -Credential $credentials -InstallDns -ReplicationSourceDC OFFICE_SRV.domolia.lan -ErrorAction stop
}
Catch {
    $_ | select-object -ExpandProperty Status

    Write-Host "Error message:" -ForegroundColor Red
    Write-Host $_.Exception.Message

    Write-Host "`nFull exception details:" -ForegroundColor Yellow
    Write-Host $_.Exception.ToString()

    Write-Host "`nStack trace:"
    Write-Host $_.ScriptStackTrace
}

$status = $result | Select-Object -ExpandProperty Status

if ($status -eq "Success") {
    ## Create forest if test OK
    Write-Host "Success - Joining existing domain..." -ForegroundColor Green

    Install-ADDSDomainController `
        -NoGlobalCatalog:$false `
        -CreateDnsDelegation:$false `
        -Credential (Get-Credential) `
        -CriticalReplicationOnly:$false `
        -DatabasePath "C:\WINDOWS\NTDS" `
        -DomainName "domolia.lan" `
        -InstallDns:$true `
        -LogPath "C:\WINDOWS\NTDS" `
        -NoRebootOnCompletion:$false `
        -SiteName "Default-First-Site-Name" `
        -SysvolPath "C:\WINDOWS\SYSVOL" `
        -Force:$true
        

#    Install-ADDSDomainController -DomainName $DomainName -Credential $credentials -InstallDns -ReplicationSourceDC OFFICE_SRV.domolia.lan -ErrorAction stop

} else {
    ## Send error message if test NOK
    Write-Host "Failed: " -ForegroundColor Red -NoNewline
    $result | Select-Object -ExpandProperty Message
}
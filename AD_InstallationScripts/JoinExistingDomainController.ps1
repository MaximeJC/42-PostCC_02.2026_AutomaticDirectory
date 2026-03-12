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

## Test-ADDSForestInstallation
Try {
    $result = Test-ADDSDomainControllerInstallation -DomainName $DomainName -Credential (Get-Credential) -InstallDns -ErrorAction stop
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

## Get result status
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
        -DomainName $DomainName `
        -InstallDns:$true `
        -LogPath "C:\WINDOWS\NTDS" `
        -NoRebootOnCompletion:$false `
        -SiteName "Default-First-Site-Name" `
        -SysvolPath "C:\WINDOWS\SYSVOL" `
        -Force:$true
} else {
    ## Send error message if test NOK
    Write-Host "Failed: " -ForegroundColor Red -NoNewline
    $result | Select-Object -ExpandProperty Message
}

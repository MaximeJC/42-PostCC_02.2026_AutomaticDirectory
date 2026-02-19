# ----------------------------------------------------------------
#
#                 CreateNewForestDomainController.ps1
#
# ----------------------------------------------------------------

using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"

Import-Module ADDSDeployment

## Get domain name and netbios name

$prg_name = "CreateNewForest"
$argsData = @(
    [Argument]::new("Domain name", $true, "domolia.lan"), 
    [Argument]::new("Netbios name", $true, "OFFICE")
)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()

    $DomainName = $form.getFormValue("Domain name")
    $NetbiosName = $form.getFormValue("Netbios name")
}
catch {
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1)
}][

## Test-ADDSForestInstallation
Try {
    $result = Test-ADDSForestInstallation -DomainName $DomainName -ErrorAction Stop
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
    Write-Host "Success - Creation of the forest..." -ForegroundColor Green

    Install-ADDSForest -DomainName $DomainName -DomainNetbiosName $NetbiosName -InstallDns

} else {
    ## Send error message if test NOK
    Write-Host "Failed: " -ForegroundColor Red -NoNewline
    $result | Select-Object -ExpandProperty Message
}
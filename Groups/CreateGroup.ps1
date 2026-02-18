using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"

$prg_name = "CreateGroup"

$argsData = @(
    [Argument]::new("Group name", $true, ""),
    [Argument]::new("Organisation Unit", $true, "OU=TEST,DC=domolia,DC=lan"),
    [Argument]::new("Group scope", $true, "DomainLocal"),
    [Argument]::new("Description", $true, "")
)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()
    New-ADGroup -Name  $form.getFormValue("Group name") `
                -GroupScope $form.getFormValue("Group scope") `
                -Description  $form.getFormValue("Description") `
                -Path  $form.getFormValue("Organisation Unit") `
}
catch {
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1)
}

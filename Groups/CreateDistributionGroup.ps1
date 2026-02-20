using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"

$prg_name = "CreateDistributionGroup"

$argsData = @(
    [Argument]::new("Group name", $true, ""),
    [Argument]::new("Organisation Unit", $true, "OU=TESTOU,DC=domolia,DC=lan"),
    [Argument]::new("Group scope", $true, "DomainLocal"),
    [Argument]::new("Description", $true, "")
)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()

    $name =  $form.getFormValue("Group name")

    # creating the asked distribution group
    New-ADGroup -Name $name `
                -GroupScope $form.getFormValue("Group scope") `
                -Description  $form.getFormValue("Description") `
                -Path  $form.getFormValue("Organisation Unit") `
                -GroupCategory Distribution # important
}
catch {
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1)
}

using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"

$prg_name = "RemoveUserToGroup"

$argsData = @(
    [Argument]::new("Group name", $true, "")
    [Argument]::new("Property name", $false, "")
)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()

    $group = $form.getFormValue("Group name")
    $property = $form.getFormValue("Property name")

    if ($property.length -eq 0) {
        Get-ADGroup -Identity $group
    }
    else {
        Get-ADGroup -Identity $group | Select-Object -Property $property
    }
}
catch {
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1);
}

using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"

$prg_name = "ReadGroupInformation"

$argsData = @(
    [Argument]::new("Group name", $true, "")
    [Argument]::new("Property name (Optionnal)", $false, "")
)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()

    $group = $form.getFormValue("Group name")
    $property = $form.getFormValue("Property name (Optionnal)")

    if ($property.length -eq 0) {
        Get-ADGroup -Identity $group # optional
    }
    else {
        CheckGroupProperty($property) # check the property
        Get-ADGroup -Identity $group | Select-Object -Property $property # filter the output
    }
}
catch {
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1);
}

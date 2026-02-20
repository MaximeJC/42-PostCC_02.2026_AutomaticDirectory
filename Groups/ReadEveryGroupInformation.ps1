using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"
using module "..\Modules\Groups.psm1"

$prg_name = "ReadEveryGroupInformation"

$argsData = @(
    [Argument]::new("Property name (Optionnal)", $false, "")
)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()
    $property = $form.getFormValue("Property name (Optionnal)")

    

    if ($property.length -eq 0) { # optionnal
        Get-ADGroup -Filter *
    }
    else {
        CheckGroupProperty($property)
        Get-ADGroup -Filter * | Select-Object -Property $property # can be filtered
    }
}
catch {
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1);
}

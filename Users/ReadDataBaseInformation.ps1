using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"
using module "..\Modules\Users.psm1"

$prg_name = "ReadDataBaseInformation"

$argsData = @(
    [Argument]::new("Attribute to retrieve", $true, "")
)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()

    $attrName = $form.getFormValue("Attribute to retrieve")
    CheckUserProperty($attrName)

    Get-ADUser -Filter * | Select-Object -Property $attrName
}
catch {
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1)
}

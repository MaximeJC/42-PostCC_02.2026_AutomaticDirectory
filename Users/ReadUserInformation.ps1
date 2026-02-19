using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"
using module "..\Modules\Users.psm1"

$prg_name = "ReadUserInformation"

$argsData = @(
    [Argument]::new("Account name", $true, ""),
    [Argument]::new("Attribute to retrieve", $true, "")
)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()

    $accountName = $form.getFormValue("Account name")
    $attrName = $form.getFormValue("Attribute to retrieve")
    CheckUserProperty($attrName)


    Get-ADUser -Identity $accountName | Select-Object -Property $attrName
}
catch {
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1)
}

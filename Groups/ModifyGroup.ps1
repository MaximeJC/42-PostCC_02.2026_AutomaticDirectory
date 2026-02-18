using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"

$prg_name = "ModifyGroup"

$argsData = @(
    [Argument]::new("Group name", $true, ""),
    [Argument]::new("Attribute to edit", $true, ""),
    [Argument]::new("New attribute value", $true, "")
)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()

    ## we can't do a -$atribute, we have to deal with ad-params
    $adParams = @{
        Identity = $form.getFormValue("Group name")
    }
    $attrName  = $form.getFormValue("Attribute to edit")
    $attrValue = $form.getFormValue("New attribute value")
    $adParams[$attrName] = $attrValue

    Set-ADGroup @adParams
}
catch {
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1)
}

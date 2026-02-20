using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"

$prg_name = "ImportGroup"

$argsData = @(
    [Argument]::new("Origin group name", $true, "")
    [Argument]::new("Destination group name", $true, "")
)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()

    $origin = $form.getFormValue("Origin group name")
    $dest = $form.getFormValue("Destination group name")

    #        get the source group                               copies all src properties into the dest's           
    Get-ADGroupMember -Identity $origin | ForEach-Object {Add-ADGroupMember -Identity $dest -Members $_.distinguishedName}
}
catch {
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1);
}

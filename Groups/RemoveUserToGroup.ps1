using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"

$prg_name = "RemoveUserToGroup"

$argsData = @(
    [Argument]::new("User name", $true, ""),
    [Argument]::new("Group name", $true, "")
)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()

    $userName = $form.getFormValue("User name")
    $groupName = $form.getFormValue("Group name")

    Remove-ADGroupMember -Identity $groupName -Members $userName -Confirm:$false
}
catch {
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1);
}

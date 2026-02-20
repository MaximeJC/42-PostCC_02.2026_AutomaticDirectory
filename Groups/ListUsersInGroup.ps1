using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"

$prg_name = "ListUsersInGroup"

$argsData = @(
    [Argument]::new("Group name", $true, "")
)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()

    $groupName = $form.getFormValue("Group name")
    Get-ADGroupMember -Identity $groupName |
    Where-Object -Property objectClass -EQ "user" | # get only users
    Select-Object -Property name # filter to display the name
}
catch {
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1);
}

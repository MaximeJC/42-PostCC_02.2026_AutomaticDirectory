using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"

$prg_name = "UserCreation"

$argsData = @(
    [Argument]::new("Account name", $true, "")
)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()

    $name = $form.getFormValue("Account name")

###########################################################################
# During the evaluation, depending on the machine,
# we could have to re-generate the secure string with these commands
###########################################################################

# mkdir \secure
# $secure = Read-Host "Enter password" -AsSecureString
# $secure | ConvertFrom-SecureString | Out-File "C:\secure\pwd.txt"

    $encrypted = Get-Content "C:\secure\pwd.txt"
    $secureString = ConvertTo-SecureString $encrypted

    Set-ADAccountPassword   -Identity $name `
                            -Reset `
                            -NewPassword $secureString `
}
catch {
    if ($user) { ## if the user is created but the group is invalid
        Remove-ADUser -Identity $user -Confirm:$false
    }
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1);
}

using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"
using module "..\Modules\Users.psm1"

$prg_name = "SaveDataBase"

$argsData = @(
    [Argument]::new("Path to the .CSV file to load", $true, ""),
    [Argument]::new("CSV delimiter", $true, "")

)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()
    $inPath = $form.getFormValue("Path to the .CSV file to load")
    $delimiter = $form.getFormValue("CSV delimiter")

    $csv = Import-Csv -Path $inPath -Delimiter $delimiter
    foreach ($line in $csv) {
        $entry = @{}

        foreach ($prop in $line.PSObject.Properties.Name) {
            if ($null -ne $line.$prop -and $line.$prop -ne "" -and $prop -ne "Type") {
                $entry[$prop] = $line.$prop
            }
        }

        try {
            if ($line.Type -eq "user") { # user import
                New-ADUser @entry
            }
            else { # group import
                New-ADGroup @entry
            }
        }
        catch { 
            Write-Host "An error occured for entry:"
            Write-Host New-Object PSObject -Property $entry 
            Write-Host "$_"
        }
    }
}   

catch {
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1)
}
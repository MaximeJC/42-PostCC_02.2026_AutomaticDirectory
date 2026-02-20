using assembly System.Windows.Forms
using assembly System.Drawing
using module "..\Modules\Form.psm1"
using module "..\Modules\Users.psm1"

$prg_name = "SaveDataBase"

$argsData = @(
    [Argument]::new("Path to save the .CSV file", $true, ""),
    [Argument]::new("CSV delimiter", $true, "")
    [Argument]::new("Comma separated Properties (ex: Name, email, ...)", $true, "")
)

try {
    $form = [CustomForm]::new($prg_name, $argsData)
    $form.askInput()
    $outPath = $form.getFormValue("Path to save the .CSV file")
    $delimiter = $form.getFormValue("CSV delimiter")
    $Properties =   $form.getFormValue("Comma separated Properties (ex: Name, email, ...)") -split ',' | ## get splitted args `
                    ForEach-Object { $_.Trim() } |  ## trim whitespaces 
                    Where-Object { $_ -ne "" }     ## skip null entries

    if ($Properties -eq "") { ## if no entries after parsing
        throw ("No properties were provided. Please specify at least one property.")
        return
    }

    # get all users / groups
    $allObjects = @()
    $allObjects += Get-ADUser  -Filter * -Properties *
    $allObjects += Get-ADGroup -Filter * -Properties *
    $allObjects = $allObjects | Sort-Object DistinguishedName -Unique

    
    $allEntries = @()
    foreach ($obj in $allObjects) {
        $entry = [ordered]@{ Type = $obj.ObjectClass } # set the type (usr/group)
        foreach ($prop in $Properties) {
            $entry[$prop] = if ($obj.PSObject.Properties.Name -contains $prop) { $obj.$prop } else { $null } # get the required properties
        }
        $allEntries += [PSCustomObject]$entry
    }

    # export as csv
    $allEntries | Export-Csv -Path $outPath -Delimiter $delimiter -NoTypeInformation -Encoding UTF8
}

catch {
    Write-Host "$_"
    Show-ErrorMessage("$_")
    exit(1)
}

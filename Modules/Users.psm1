function CheckUserProperty([string]$property) {
    $sample = Get-ADUser -Filter * -ResultSetSize 1 -Properties *

    $availableProperties = $sample |
        Get-Member -MemberType Properties |
        Select-Object -ExpandProperty Name

    if ($availableProperties -notcontains $property) {
        throw "The property '$property' doesn't exist in AD users."
    }
}

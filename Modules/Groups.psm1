function CheckGroupProperty([string]$property) {
    $sample = Get-ADGroup -Filter * -ResultSetSize 1 # get a group sample
    $availableProperties = $sample | Get-Member -MemberType Properties | Select-Object -ExpandProperty Name  ## get all fields
    if ($availableProperties -notcontains $property) {
        throw "The property '$property' doesn't exists in groups"
    }
}
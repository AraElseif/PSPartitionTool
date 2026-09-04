Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -File |
    ForEach-Object {. $_.FullName}

$PublicFunctions = Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -File
$PublicFunctions |
    ForEach-Object {. $_.FullName}

Export-ModuleMember -Function $PublicFunctions.BaseName
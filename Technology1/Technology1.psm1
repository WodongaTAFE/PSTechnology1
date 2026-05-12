# Dot source public/private functions
$functions = @(Get-ChildItem -Path "$PSScriptRoot\Public" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)

foreach ($Function in $functions) {
    . $Function.FullName
}

Export-ModuleMember -Function $functions.BaseName

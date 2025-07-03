# Open a terminal with two Ubuntu WSL tabs.

$wsls = wsl --list --quiet `
    | ForEach-Object { $_ -replace "`0", "" }
$ubuntuWsl = $wsls `
    | Where-Object { $_.StartsWith("Ubuntu") } `
    | Select-Object -First 1

wt `
    new-tab `
        --profile "$ubuntuWsl" `
        `; `
    new-tab `
        --profile "$ubuntuWsl" `


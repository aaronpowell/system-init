$env:POSH_GIT_ENABLED = $true
Import-Module nvm
Import-Module posh-git

oh-my-posh --init --shell pwsh --config D:\OneDrive\oh-my-posh.json | Invoke-Expression

Import-Module -Name Terminal-Icons
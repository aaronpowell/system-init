function Install-PowerShellModule {
    param(
        [string]
        [Parameter(Mandatory = $true)]
        $ModuleName,

        [ScriptBlock]
        [Parameter(Mandatory = $true)]
        $PostInstall = {}
    )

    if (!(Get-Command -Name $ModuleName -ErrorAction SilentlyContinue)) {
        Write-Host "Installing $ModuleName"
        Install-Module -Name $ModuleName -Scope CurrentUser -Confirm $true
        Import-Module $ModuleName -Confirm

        Invoke-Command -ScriptBlock $PostInstall
    } else {
        Write-Host "$ModuleName was already installed, skipping"
    }
}

Write-Host Installing PowerShell Modules

Install-PowerShellModule 'Posh-Git' { }
Install-PowerShellModule 'oh-my-posh' { }
Install-PowerShellModule 'PSReadLine' { }
Install-PowerShellModule 'Terminal-Icons' { }
Install-PowerShellModule 'nvm' {
    Install-NodeVersion latest
    Set-NodeVersion -Persist User latest
}

Write-Host Setting up dotfiles

Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/aaronpowell/system-init/master/common/.gitconfig' -OutFile (Join-Path $env:USERPROFILE '.gitconfig')
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/aaronpowell/system-init/master/windows/Microsoft.PowerShell_profile.ps1' -OutFile $PROFILE

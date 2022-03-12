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

Write-Host Installing winget packages

$packages = @(
    # Dev Tools
    'Git.Git',
    'GitHub.cli',
    'LINQPad.LINQPad.7',
    'Microsoft.WindowsTerminal.Preview',
    'Docker.DockerDesktop',
    'icsharpcode.ILSpy',

    # Editors
    'Microsoft.VisualStudioCode.Insiders',

    # Inspectors
    'Telerik.Fiddler.Classic',
    'Postman.Postman',

    # Browsers
    'Mozilla.Firefox',
    'Google.Chrome',
    'Microsoft.Edge.Dev',
    'Microsoft.Edge.Beta',

    # Chat
    'Discord.Discord',
    'SlackTechnologies.Slack',
    'OpenWhisperSystems.Signal',

    # Video
    'OBSProject.OBSStudio',
    'Nvidia.Broadcast',
    'XSplit.VCam',
    'VB-Audio.Voicemeeter.Potato',
    'Elgato.StreamDeck',
    'Elgato.ControlCenter',

    # Misc
    'Microsoft.Powershell.Preview',
    'Microsoft.PowerToys',
    'Microsoft.OneDrive',
    'Nvidia.GeForceExperience',
    'Logitech.Options',
    'NickeManarin.ScreenToGif',
    'Valve.Steam',
    'Microsoft.Office'
)

$packages | ForEach-Object { winget install --id $_ --source winget }

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

Write-Host Installing additional software

wsl --install

Write-Host Manuall install the following
Write-Host "- Wally (moonlander tool)"
Write-Host "- Visual Studio DF"
Write-Host "- Edge Canary"
Write-Host "- caskaydiacove nf: https://www.nerdfonts.com/font-downloads"

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
        Install-Module -Name $ModuleName -Scope CurrentUser
        Import-Module $ModuleName

        Invoke-Command -ScriptBlock $PostInstall
    }
    else {
        Write-Host "$ModuleName was already installed, skipping"
    }
}

Write-Host "Before we start, here's a few question"

$streaming = Read-Host "Setup streaming? (y/n)"
$desktop = Read-Host "Setup desktop? (y/n)"

Write-Host Installing winget packages

$packages = @(
    # Dev Tools
    'Git.Git',
    'GitHub.cli',
    'LINQPad.LINQPad.7',
    'Microsoft.WindowsTerminal.Preview',
    'Docker.DockerDesktop',
    'icsharpcode.ILSpy',
    'JanDeDobbeleer.OhMyPosh',

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

    # Misc
    'Microsoft.Powershell.Preview',
    'Microsoft.PowerToys',
    'Microsoft.OneDrive',
    'NickeManarin.ScreenToGif',
    'Microsoft.Office'
)

if ($streaming -eq "y") {
    $packages += 'OBSProject.OBSStudio'
    $packages += 'Nvidia.Broadcast'
    $packages += 'XSplit.VCam'
    $packages += 'VB-Audio.Voicemeeter.Potato'
    $packages += 'Elgato.StreamDeck'
    $packages += 'Elgato.ControlCenter'
}

if ($desktop -eq "y") {
    $packages += 'Nvidia.GeForceExperience'
    $packages += 'Logitech.Options'
    $packages += 'Valve.Steam'
}

$packages | ForEach-Object { winget install --id $_ --source winget }

Write-Host Installing PowerShell Modules

Set-ExecutionPolicy -ExecutionPolicy Unrestricted

Install-PowerShellModule 'Posh-Git' { }
Install-PowerShellModule 'PSReadLine' { }
Install-PowerShellModule 'Terminal-Icons' { }
Install-PowerShellModule 'nvm' {
    Install-NodeVersion latest
    Set-NodeVersion -Persist User latest
}

Write-Host Setting up dotfiles

$repoBaseUrl = 'https://raw.githubusercontent.com/aaronpowell/system-init/main'

Invoke-WebRequest -Uri "$repoBaseUrl/common/.gitconfig" -OutFile (Join-Path $env:USERPROFILE '.gitconfig')
Invoke-WebRequest -Uri "$repoBaseUrl/windows/Microsoft.PowerShell_profile.ps1" -OutFile $PROFILE
Invoke-WebRequest -Uri "$repoBaseUrl/windows/Microsoft.PowerShell_profile.ps1" -OutFile $PROFILE.Replace("WindowsPowerShell", "PowerShell")

Write-Host Installing additional software

wsl --install
wsl --exec "curl $repoBaseUrl/linux/setup.sh | bash"

Write-Host Manuall install the following
Write-Host "- Wally (moonlander tool)"
Write-Host "- Visual Studio DF"
Write-Host "- Edge Canary"
Write-Host "- caskaydiacove nf: https://www.nerdfonts.com/font-downloads"

if ($streaming -eq "y") {
    Write-Host OBS Plugins
    Write-Host "- Stream Elements"
    Write-Host "- Advanced Scene Switcher"
    Write-Host "- OBS WebSockets"
    Write-Host "- StreamFX"
}

if ($desktop -ne "y") {
    Write-Host Remember to Update path for oh-my-posh
}

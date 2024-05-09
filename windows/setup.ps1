Write-Host "Before we start, here's a few question"

$streaming = Read-Host "Setup streaming? (y/n)"
$desktop = Read-Host "Setup desktop? (y/n)"

wsl --install

Write-Host Installing winget packages

$packages = @(
    # Dev Tools
    'Git.Git',
    'GitHub.cli',
    'LINQPad.LINQPad.8',
    'Microsoft.WindowsTerminal.Preview',
    'Microsoft.AzureCLI',
    'Microsoft.Azd',
    'Docker.DockerDesktop',
    # 'suse.RancherDesktop',
    'icsharpcode.ILSpy',
    'JanDeDobbeleer.OhMyPosh',
    'jqlang.jq',

    # Editors
    'Microsoft.VisualStudioCode.Insiders',
    'Microsoft.VisualStudioCode',
    'Microsoft.VisualStudio.2022.Enterprise',

    # Inspectors
    'Telerik.Fiddler.Classic',
    # 'Postman.Postman',
    # 'ChilliCream.BananaCakePop',

    # Browsers
    'Mozilla.Firefox',
    'Google.Chrome',
    'Microsoft.Edge.Dev',
    'Microsoft.Edge.Beta',
    'Microsoft.Edge.Canary'

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
    # $packages += 'Nvidia.Broadcast'
    # $packages += 'XSplit.VCam'
    # $packages += 'VB-Audio.Voicemeeter.Potato'
    $packages += 'Elgato.StreamDeck'
    $packages += 'Elgato.ControlCenter'
}

if ($desktop -eq "y") {
    $packages += 'Nvidia.GeForceExperience'
    $packages += 'Logitech.Options'
    $packages += 'Valve.Steam'
}

$packages | ForEach-Object { winget install --id $_ --source winget }

Write-Host Setting up PowerShell

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/aaronpowell/system-init/main/windows/setup-powershell.ps1'))
pwsh -c "Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/aaronpowell/system-init/main/windows/setup-powershell.ps1'))"
pwsh -c "gh extension install github/gh-copilot"

Write-Host Manuall install the following
Write-Host "- Visual Studio DF"
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

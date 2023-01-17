wsl --install

Write-Host Installing winget packages

$packages = @(
    # Dev Tools
    'Git.Git',
    'GitHub.cli',
    'LINQPad.LINQPad.7',
    'Microsoft.WindowsTerminal.Preview',
    # 'Docker.DockerDesktop',
    'RancherDesktop',
    'icsharpcode.ILSpy',

    # Editors
    'Microsoft.VisualStudioCode.Insiders',

    # Inspectors
    'Telerik.Fiddler.Classic',
    'Postman.Postman',
    'ChilliCream.BananaCakePop',

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
    'Valve.Steam',
    'Microsoft.Office',

    # Desktop features

    # Video
    # 'OBSProject.OBSStudio',
    # 'Nvidia.Broadcast',
    # 'XSplit.VCam',
    # 'VB-Audio.Voicemeeter.Potato',
    # 'Elgato.StreamDeck',
    # 'Elgato.ControlCenter',

    # 'Nvidia.GeForceExperience',
    # 'Logitech.Options'
)

$packages | ForEach-Object { winget install --id $_ --source winget }

Write-Host Setting up PowerShell

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/aaronpowell/system-init/master/windows/setup-powershell.ps1'))
pwsh -c "Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/aaronpowell/system-init/master/windows/setup-powershell.ps1'))"

Write-Host Manuall install the following
Write-Host "- Visual Studio DF"
Write-Host "- Edge Canary"
Write-Host "- caskaydiacove nf: https://www.nerdfonts.com/font-downloads"

Write-Host OBS Plugins
Write-Host "- Stream Elements"
Write-Host "- Advanced Scene Switcher"
Write-Host "- OBS WebSockets"
Write-Host "- StreamFX"

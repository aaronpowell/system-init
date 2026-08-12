Write-Host "Before we start, here's a few question"

$streaming = Read-Host "Setup streaming? (y/n)"
$desktop = Read-Host "Setup desktop? (y/n)"
$gaming = Read-Host "Setup gaming? (y/n)"
$windowsFeatures = Read-Host "Setup Windows features / developer UX? (y/n)"

function Set-WindowsExplorerPreferences {
    Write-Host "Configuring Windows Explorer preferences"

    $explorerAdvanced = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    $explorerRoot = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'

    if (-not (Test-Path $explorerAdvanced)) {
        New-Item -Path $explorerAdvanced -Force | Out-Null
    }

    Set-ItemProperty -Path $explorerAdvanced -Name 'AutoCheckSelect' -Type DWord -Value 1 -Force
    Set-ItemProperty -Path $explorerAdvanced -Name 'SingleClick' -Type DWord -Value 1 -Force
    Set-ItemProperty -Path $explorerRoot -Name 'IconUnderline' -Type DWord -Value 2 -Force
}

function Enable-DeveloperModeAndLongPaths {
    Write-Host "Enabling Developer Mode and long path support"

    $devModeKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock'
    if (-not (Test-Path $devModeKey)) {
        New-Item -Path $devModeKey -Force | Out-Null
    }

    Set-ItemProperty -Path $devModeKey -Name 'AllowDevelopmentWithoutDevLicense' -Type DWord -Value 1 -Force
    Set-ItemProperty -Path $devModeKey -Name 'AllowAllTrustedApps' -Type DWord -Value 1 -Force

    $fileSystemKey = 'HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem'
    if (-not (Test-Path $fileSystemKey)) {
        New-Item -Path $fileSystemKey -Force | Out-Null
    }

    Set-ItemProperty -Path $fileSystemKey -Name 'LongPathsEnabled' -Type DWord -Value 1 -Force

    try {
        $feature = Get-WindowsOptionalFeature -Online -FeatureName 'MicrosoftWindowsSudo' -ErrorAction Stop
        if (-not $feature.State -eq 'Enabled') {
            Enable-WindowsOptionalFeature -Online -FeatureName 'MicrosoftWindowsSudo' -All -NoRestart
        }
    }
    catch {
        Write-Host 'sudo for Windows is not available on this build; skipping.'
    }
}

if ($windowsFeatures -eq 'y') {
    Set-WindowsExplorerPreferences
    Enable-DeveloperModeAndLongPaths
}

Write-Host "Enabling WSL and installing Ubuntu"
wsl --install --distribution Ubuntu

Write-Host Installing winget packages

$packages = @(
    # Dev Tools
    'Git.Git',
    'GitHub.cli',
    'LINQPad.LINQPad.9',
    'Microsoft.WindowsTerminal.Preview',
    'Microsoft.AzureCLI',
    'Microsoft.Azd',
    'Docker.DockerDesktop',
    # 'suse.RancherDesktop',
    'icsharpcode.ILSpy',
    'JanDeDobbeleer.OhMyPosh',
    'jqlang.jq',
    'Logitech.OptionsPlus',
    'Okta.OktaVerify',
    'dotPDN.PaintDotNet',
    'TomEnglert.RegionToShare',

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
}

if ($gaming -eq "y") {
    $packages += 'Valve.Steam'
    $packages += 'GOG.Galaxy'
    $packages += 'Blizzard.BattleNet'
}

$packages | ForEach-Object { winget install --id $_ --source winget }

function Get-GitHubReleaseAsset {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Owner,

        [Parameter(Mandatory = $true)]
        [string]$Repo,

        [Parameter(Mandatory = $true)]
        [string]$Pattern
    )

    $headers = @{
        Accept = 'application/vnd.github+json'
        'User-Agent' = 'system-init'
    }

    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$Owner/$Repo/releases/latest" -Headers $headers
    $asset = $release.assets | Where-Object { $_.name -match $Pattern } | Sort-Object name | Select-Object -First 1

    if (-not $asset) {
        throw "Could not find a matching release asset for $Owner/$Repo using pattern '$Pattern'"
    }

    return $asset.browser_download_url
}

function Install-GitHubCopilotApp {
    $arch = if ((Get-CimInstance Win32_ComputerSystem).SystemType -match 'ARM') { 'arm64' } else { 'x64' }
    $installerPath = Join-Path $env:TEMP "GitHub-Copilot-windows-$arch.msi"

    Write-Host "Installing GitHub Copilot desktop app"
    $assetUrl = Get-GitHubReleaseAsset -Owner 'github' -Repo 'app' -Pattern "GitHub-Copilot-windows-$arch\\.msi$"
    Invoke-WebRequest -Uri $assetUrl -OutFile $installerPath
    Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" /qn /norestart" -Wait -NoNewWindow
}

function Install-MonaspaceFonts {
    $fontArchivePath = Join-Path $env:TEMP 'monaspace-variable.zip'
    $targetFontsDir = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'

    Write-Host "Installing Monaspace fonts"
    $assetUrl = Get-GitHubReleaseAsset -Owner 'githubnext' -Repo 'monaspace' -Pattern 'monaspace-variable-v.*\.zip$'
    Invoke-WebRequest -Uri $assetUrl -OutFile $fontArchivePath

    $extractDir = Join-Path $env:TEMP ("monaspace-" + [Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $extractDir -Force | Out-Null
    Expand-Archive -Path $fontArchivePath -DestinationPath $extractDir -Force

    New-Item -ItemType Directory -Path $targetFontsDir -Force | Out-Null
    Get-ChildItem -Path $extractDir -Recurse -Include *.ttf,*.otf | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $targetFontsDir -Force
    }
}

Install-GitHubCopilotApp
Install-MonaspaceFonts

Write-Host Setting up PowerShell

gh extension install github/gh-aw

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/aaronpowell/system-init/main/windows/setup-powershell.ps1'))
# pwsh -c "Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/aaronpowell/system-init/main/windows/setup-powershell.ps1'))"
& C:\Program Files\PowerShell\7-preview\pwsh.exe -c "Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/aaronpowell/system-init/main/windows/setup-powershell.ps1'))"

Write-Host Manuall install the following
Write-Host "- Visual Studio DF"
Write-Host "- caskaydiacove nf: https://www.nerdfonts.com/font-downloads"
Write-Host "- WhatsApp (no official winget package found)"

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

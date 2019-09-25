function Install-Application {
    param(
        [string]
        [Parameter(Mandatory = $true)]
        $ApplicationName,

        [ScriptBlock]
        [Parameter(Mandatory = $true)]
        $InstallScript
    )

    if (!(Get-Command -Name $ApplicationName -ErrorAction SilentlyContinue)) {
        Write-Host "Installing $ApplicationName"
        Invoke-Command -ScriptBlock $InstallScript
    } else {
        Write-Host "$ApplicationName was already installed, skipping"
    }
}

function Install-PowerShellModule {
    param(
        [string]
        [Parameter(Mandatory = $true)]
        $ModuleName,

        [ScriptBlock]
        [Parameter]
        $PostInstall = {}
    )

    if (!(Get-Command -Name $ModuleName -ErrorAction SilentlyContinue)) {
        Write-Host "Installing $ModuleName"
        Install-Module -Name $ModuleName -Scope CurrentUser -Confirm $true
        Import-Module $ModuleName

        Invoke-Command -ScriptBlock $PostInstall
    } else {
        Write-Host "$ModuleName was already installed, skipping"
    }
}

Install-Application 'code-insiders' {
    $outFile = Join-Path $env:TEMP 'vscode-insiders.exe'
    Invoke-WebRequest -Uri 'https://aka.ms/win32-x64-user-insider' -OutFile $outFile -UseBasicParsing

    Start-Process -FilePath $outFile -ArgumentList [[ '/SILENT' ]]
}

Install-Application 'git' {
    $outFile = Join-Path $env:TEMP 'git.exe'
    Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.21.0.windows.1/Git-2.21.0-64-bit.exe' -OutFile $outFile -UseBasicParsing

    Start-Process -FilePath $outFile -ArgumentList [[ '/SILENT' ]]

    Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/aaronpowell/system-init/master/common/.gitconfig' -OutFile (Join-Path $env:USERPROFILE '.gitconfig')
}

Install-Application "C:\Program Files\ConEmu\ConEmu64.exe" {
    $outFile = Join-Path $env:TEMP 'conemu65.exe'
    Invoke-WebRequest -Uri 'https://github.com/Maximus5/ConEmu/releases/download/v19.03.10/ConEmuSetup.190310.exe' -OutFile $outFile -UseBasicParsing

    Start-Process -FilePath $outFile -ArgumentList [[ '/SILENT' ]]

    Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/aaronpowell/system-init/master/windows/ConEmu.xml' -OutFile (Join-Path $env:APPDATA 'ConEmu.xml')
}

Install-Application 'go' {
    $outFile = Join-Path $env:TEMP 'go.msi'
    Invoke-WebRequest -Uri 'https://dl.google.com/go/go1.12.1.windows-amd64.msi' -OutFile $outFile -UseBasicParsing

    # Start-Process -FilePath $outFile -ArgumentList [[ '/SILENT' ]]

}

Install-Module 'Posh-Git'
Install-Module 'nvm' { Install-NodeVersion latest }
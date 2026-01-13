# =========================================================================
# Vintage Story Mod Update Script
# This script reads settings from a configuration file to update mods
# locally and then transfer them to an FTP server or a local test folder.
# =========================================================================

# --- SCRIPT EXECUTION ---
# Get the script's directory and the path to the configuration file.
$scriptPath = $PSScriptRoot
$configPath = Join-Path -Path $scriptPath -ChildPath "config.psd1"

# Check if the configuration file exists.
if (-not (Test-Path $configPath)) {
    Write-Host "Error: The configuration file 'config.psd1' was not found." -ForegroundColor Red
    exit
}

# Load the configuration data.
Write-Host "Loading settings from the configuration file..." -ForegroundColor Cyan
try {
    $config = Import-PowerShellDataFile -Path $configPath
} catch {
    Write-Host "An error occurred while reading the configuration file." -ForegroundColor Red
    exit
}

Write-Host "Hello! Let's start updating your mods..." -ForegroundColor Cyan

# 1. Prepare the local folder
Write-Host "Step 1/3: Preparing the local mods folder..."
if (-not (Test-Path $config.LocalModsFolder)) {
    Write-Host "Folder not found. Creating it now..." -ForegroundColor Yellow
    New-Item -Path $config.LocalModsFolder -ItemType Directory | Out-Null
}

# 2. Execute Modsupdater
Write-Host "Step 2/3: Updating mods with Modsupdater..."
try {
    $modsupdaterDirectory = Split-Path -Path $config.ModsupdaterPath
    $arguments = @()
    if ($config.ModsupdaterArguments -ne '') {
        $arguments += $config.ModsupdaterArguments.Split(' ')
    }
    $arguments += "--modspath"
    $arguments += "`"$($config.LocalModsFolder)`""

    Start-Process -FilePath $config.ModsupdaterPath -ArgumentList $arguments -Wait -NoNewWindow -WorkingDirectory $modsupdaterDirectory
} catch {
    Write-Host "An error occurred while running Modsupdater." -ForegroundColor Red
    exit
}

# 3. Synchronization (FTP or Local Simulation)
# =========================================================================
Write-Host "Step 3/3: Synchronizing files..."

if ($config.TestMode -eq $true) {
    # --- TEST MODE LOGIC ---
    Write-Host "[TEST MODE] Simulating transfer to local folder..." -ForegroundColor Yellow
    Write-Host "Target: $($config.LocalMockRemotePath)" -ForegroundColor Yellow

    if (-not (Test-Path $config.LocalMockRemotePath)) {
        New-Item -Path $config.LocalMockRemotePath -ItemType Directory | Out-Null
    }

    # Robocopy /MIR behaves exactly like lftp mirror --delete or WinSCP synchronize
    # /R:0 /W:0 avoids hanging on retry if a file is locked
    robocopy $config.LocalModsFolder $config.LocalMockRemotePath /MIR /R:0 /W:0
}
else {
    # --- REAL FTP LOGIC ---
    try {
        Write-Host "Connecting to FTP server: $($config.FtpServer)..." -ForegroundColor Cyan
        
        $scriptContent = @"
option transfer binary
open sftp://$($config.FtpUsername):$($config.FtpPassword)@$($config.FtpServer)
synchronize remote "$($config.LocalModsFolder)" "$($config.RemoteModsPath)"
close
exit
"@
        $tempScriptPath = [System.IO.Path]::GetTempFileName()
        $scriptContent | Out-File -FilePath $tempScriptPath -Encoding ascii

        & "$($config.WinscpPath)" /script="$tempScriptPath" /loglevel=0
        Remove-Item -Path $tempScriptPath -Force
    } catch {
        Write-Host "An error occurred during FTP synchronization." -ForegroundColor Red
        exit
    }
}

Write-Host "Update completed successfully!" -ForegroundColor Green
if ($config.TestMode -eq $true) {
    Write-Host "Note: Files were synced to your local test folder (Test Mode)." -ForegroundColor Yellow
}
# =========================================================================
# Vintage Story Mod Update Script
# This script reads settings from a configuration file to update mods
# locally and then transfer them to an FTP server using WinSCP.
# =========================================================================

# --- SCRIPT EXECUTION ---
# Get the script's directory and the path to the configuration file.
$scriptPath = $PSScriptRoot
$configPath = Join-Path -Path $scriptPath -ChildPath "config.psd1"

# Check if the configuration file exists.
if (-not (Test-Path $configPath)) {
    Write-Host "Error: The configuration file 'config.psd1' was not found in the same folder." -ForegroundColor Red
    Write-Host "Please create the file and fill in your settings." -ForegroundColor Red
    exit
}

# Load the configuration data.
Write-Host "Loading settings from the configuration file..." -ForegroundColor Cyan
try {
    $config = Import-PowerShellDataFile -Path $configPath
} catch {
    Write-Host "An error occurred while reading the configuration file. Please check its content." -ForegroundColor Red
    exit
}

Write-Host "Hello! Let's start updating your mods..." -ForegroundColor Cyan

# 1. Prepare the local folder
Write-Host "Step 1/3: Preparing the local mods folder..."

# We will not delete the folder, as Modsupdater handles this.
# We will only create the folder if it does not exist.
if (-not (Test-Path $config.LocalModsFolder)) {
    Write-Host "The folder was not found. Creating it now..." -ForegroundColor Yellow
    New-Item -Path $config.LocalModsFolder -ItemType Directory | Out-Null
}

# 2. Execute Modsupdater
Write-Host "Step 2/3: Updating mods with Modsupdater..."
try {
    # Get the directory of the executable using Split-Path.
    $modsupdaterDirectory = Split-Path -Path $config.ModsupdaterPath

    # Build the argument list.
    $arguments = @()
    if ($config.ModsupdaterArguments -ne '') {
        $arguments += $config.ModsupdaterArguments.Split(' ')
    }
    
    $arguments += "--modspath"
    $arguments += "`"$($config.LocalModsFolder)`""

    # Start the process from the correct working directory.
    # We use the directory we just extracted.
    Start-Process -FilePath $config.ModsupdaterPath -ArgumentList $arguments -Wait -NoNewWindow -WorkingDirectory $modsupdaterDirectory
} catch {
    Write-Host "An error occurred while running Modsupdater. Please check the path in your config file." -ForegroundColor Red
    exit
}

# 3. FTP Synchronization with WinSCP
# =========================================================================
Write-Host "Step 3/3: Sending updated mods to the FTP server..."
try {
    # Create a temporary file for the WinSCP script.
    $scriptContent = @"
option transfer binary
open sftp://$($config.FtpUsername):$($config.FtpPassword)@$($config.FtpServer)
synchronize remote "$($config.LocalModsFolder)" "$($config.RemoteModsPath)"
close
exit
"@

    $scriptPath = [System.IO.Path]::GetTempFileName()
    $scriptContent | Out-File -FilePath $scriptPath -Encoding ascii

    # Execute WinSCP using the temporary script
    & "$config.WinscpPath" /script="$scriptPath" /loglevel=0

    # Cleanup
    Remove-Item -Path $scriptPath -Force

} catch {
    Write-Host "An error occurred during FTP synchronization. Check your connection and server information in the config file." -ForegroundColor Red
    exit
}

Write-Host "Update completed successfully! Your mods are up to date on the server." -ForegroundColor Green
# Vintage Story Server Utilities

A collection of utility scripts for managing a Vintage Story server. This repository includes tools for automating mod updates and file synchronization between a local machine and a remote server.

## Features

*   **Local Update**: Automatically runs `ModsUpdater` to fetch the latest versions of your mods.
*   **Automatic Sync**: Synchronizes your local mods folder with a remote server via FTP/SFTP.
*   **Smart Mirroring**: 
    *   On **Linux**, uses `lftp` (remote) and `rsync` (test mode).
    *   On **Windows**, uses `WinSCP` (remote) and `robocopy` (test mode).
*   **Test Mode**: Allows you to simulate the entire process locally without any FTP connection to verify your setup.

## Project Structure

*   `linux/`: Bash scripts for Linux users.
    *   `config.sh`: Configuration file with all settings.
    *   `update_mods.sh`: Main update script.
*   `windows/`: PowerShell scripts for Windows users.
    *   `config.psd1`: Configuration file with all settings.
    *   `update_mods.ps1`: Main update script.
    *   `run_updater.bat`: Batch launcher for easy execution.

---
> [!CAUTION]
> ### ⚠️ Warning: Mirror Synchronization
> This script uses a **Mirror** behavior (`synchronize remote`). 
> 
> It makes the server folder **exactly identical** to your local folder. If your server's mods folder contains essential game files (like `VSSurvivalMod.dll`, `VSEssentials.dll`, `VSCreativeMod.dll` etc.) and these files are not present in your local computer's folder, **the script will delete them from the server**.
>
> **Prevention:**
> 1. Always ensure you are syncing to a "clean" mods folder, or
> 2. Copy the server's core DLL files (or the other files present) to your local folder once so the script won't delete them.
---

## Getting Started

### Prerequisites

1.  **ModsUpdater**: Download the latest version of ModsUpdater:
    - [ModsUpdater for Windows](https://mods.vintagestory.at/modsupdater)
    - [ModsUpdater for Linux](https://mods.vintagestory.at/modsupdaterforlinux)
2.  **FTP Client**:
    *   **Windows**: Install [WinSCP](https://winscp.net/).
    *   **Linux**: Install `lftp` (e.g., `sudo apt install lftp`).

### 1. Test Mode (Highly Recommended)

Before connecting to your production server, you can test the logic locally:
1.  Open your configuration file (`linux/config.sh` or `windows/config.psd1`).
2.  Set `TestMode` to `true`.
3.  Set `LocalMockRemotePath` to a local folder that will act as your "fake" server.
4.  Run the script. It will update the mods and "transfer" them to your mock folder.

### 2. Production Setup

Once satisfied with the test:
1.  Set `TestMode` to `false` in the config file.
2.  Fill in your actual FTP/SFTP credentials (`Username`, `Password`, `Server Address`).
3.  Ensure the `RemoteModsPath` is correct for your hosting provider.

---

## Usage

### Windows

#### Option 1: Using the Batch Launcher (Easiest)
1.  Navigate to the `windows/` folder.
2.  Edit `config.psd1` with your settings.
3.  Double-click `run_updater.bat` to launch the update process.
    - The console will remain open after execution so you can see the results.

#### Option 2: Using PowerShell Directly
1.  Navigate to the `windows/` folder.
2.  Edit `config.psd1` with your settings.
3.  Right-click `update_mods.ps1` and select **Run with PowerShell**.

### Linux
1.  Navigate to the `linux/` folder.
2.  Edit `config.sh` with your settings.
3.  Make the script executable: `chmod +x update_mods.sh`.
4.  Run the script: `./update_mods.sh`.

---

## File Explanations

### Windows/run_updater.bat
The batch file serves as a simple launcher for the PowerShell script:
- **`@echo off`**: Suppresses command output so only the script's messages are shown.
- **`PowerShell -NoProfile -ExecutionPolicy Bypass`**: Launches PowerShell without user profile and bypasses execution policy restrictions, allowing the script to run even if PowerShell restrictions are enabled.
- **`-File "%~dp0update_mods.ps1"`**: Executes the PowerShell script from the same directory as the batch file (`%~dp0` expands to the batch file's directory).
- **`pause`**: Keeps the console window open after execution completes, allowing you to see the final results and any error messages.

This provides a user-friendly way to run the updater without needing to open PowerShell manually.

### Windows/update_mods.ps1
The main PowerShell script that orchestrates the entire update process:
1. **Loads Configuration**: Reads settings from `config.psd1`.
2. **Prepares Local Folder**: Creates the local mods folder if it doesn't exist.
3. **Runs ModsUpdater**: Executes ModsUpdater to download the latest mod versions.
4. **Synchronizes Files**: 
   - In **Test Mode**: Uses `robocopy` to mirror files to a local test folder.
   - In **Production Mode**: Uses `WinSCP` to sync files to your remote FTP/SFTP server via SFTP (line 88).

### Windows/config.psd1
The configuration file containing all user-specific settings:
- **Paths**: LocalModsFolder, ModsupdaterPath, WinscpPath, LocalMockRemotePath, RemoteModsPath
- **FTP Credentials**: FtpServer, FtpUsername, FtpPassword
- **Modsupdater Arguments**: Additional command-line arguments for ModsUpdater
- **Test Mode Flag**: Boolean to switch between test and production modes

### Linux/update_mods.sh
The main Bash script for Linux that orchestrates the entire update process:
1. **Loads Configuration**: Reads settings from `config.sh`.
2. **Prepares Local Folder**: Creates the local mods folder if it doesn't exist.
3. **Runs ModsUpdater**: Executes ModsUpdater to download the latest mod versions.
4. **Synchronizes Files**:
   - In **Test Mode**: Uses `rsync` to mirror files to a local test folder.
   - In **Production Mode**: Uses `lftp` to sync files to your remote FTP/SFTP server.

### Linux/config.sh
The configuration file containing all user-specific settings:
- **Paths**: LOCAL_MODS_FOLDER, MODSUPDATER_PATH, LOCAL_MOCK_REMOTE_PATH, REMOTE_MODS_PATH
- **FTP Credentials**: FTP_SERVER, FTP_USERNAME, FTP_PASSWORD
- **Modsupdater Arguments**: Additional command-line arguments for ModsUpdater
- **Test Mode Flag**: Boolean to switch between test and production modes

---

## Compatibility

*   **Windows**: Requires PowerShell 5.1+ and WinSCP.
*   **Linux**: Requires Bash, lftp, and rsync.

---

## Troubleshooting

### Windows
- **Script won't run**: Right-click `run_updater.bat` > Properties > Unblock (if available), then try again.
- **PowerShell execution policy error**: The `run_updater.bat` file bypasses this automatically.
- **SFTP connection fails (line 88)**: The script uses SFTP by default. If your server doesn't support SFTP, you can modify the connection protocol by changing `open sftp://` to `open ftp://` in the `update_mods.ps1` script (around line 88). However, FTP is less secure than SFTP and should only be used if necessary.

### Linux
- **Permission denied**: Run `chmod +x update_mods.sh` to make the script executable.
- **lftp not found**: Install with `sudo apt install lftp` (Debian/Ubuntu) or equivalent for your distro.
- **Connection issues**: Some hosting providers may require FTP instead of SFTP. Check your hosting documentation or contact support if SFTP doesn't work.

# Vintage Story Server Utilities

A collection of utility scripts for managing a Vintage Story server. This repository includes tools for automating mod updates and file synchronization.

## Features

*   **Local Update**: Uses `ModsUpdater` to fetch the latest versions of your mods.
*   **Automatic Sync**: Automatically uploads updated mods to your remote server via FTP/SFTP.
*   **Test Mode**: Allows you to simulate the process by syncing files to a local folder instead of a remote server.

## Files and Scripts

This project is organized by operating system.

### Windows (`windows/`)
* **`update_mods.ps1`**: The main PowerShell script.
* **`config.psd1`**: Configuration file for Windows.
* **Tools used**: WinSCP, `robocopy` (built-in), and PowerShell.

### Linux (`linux/`)
* **`update_mods.sh`**: The main Bash script.
* **`config.sh`**: Configuration file for Linux.
* **Tools used**: `lftp`, `rsync`, and Bash.

## Getting Started

### Prerequisites

1.  **ModsUpdater**: Ensure you have the **ModsUpdater** program on your computer.
2.  **FTP Client**:
    *   **Windows**: Install **WinSCP**.
    *   **Linux**: Install **`lftp`** (e.g., `sudo apt install lftp`).

### Test Mode (Simulation)

Before deploying to a real server, you can test the script:
1.  Open your configuration file (`config.psd1` or `config.sh`).
2.  Set `TestMode` to `true`.
3.  Define a `LocalMockRemotePath` where you want the "server" files to be simulated.
4.  Run the script. This will verify if `ModsUpdater` works and if files are correctly organized without needing FTP credentials.

### Production Setup

1.  Set `TestMode` to `false` in your config file.
2.  Fill in your FTP/SFTP credentials (`Username`, `Password`, `Server Address`).
3.  Ensure the `RemoteModsPath` matches the folder structure on your host.

### Running the Script

**Windows:**
1.  Right-click on **`windows/update_mods.ps1`**.
2.  Select **"Run with PowerShell"**.

**Linux:**
1.  Open a terminal.
2.  Make the script executable: `chmod +x linux/update_mods.sh`
3.  Run the script: `./linux/update_mods.sh`

---

## Compatibility

* **Windows**: Requires PowerShell 5.1+ and WinSCP.
* **Linux**: Requires Bash, lftp, and rsync (optional but recommended for test mode).
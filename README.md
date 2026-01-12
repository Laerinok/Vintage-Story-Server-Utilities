# Vintage Story Server Utilities

A collection of utility scripts for managing a Vintage Story server. This repository includes tools for automating mod updates and file synchronization.

## Files and Scripts

This project is organized by operating system.

### Windows (`windows/`)
* **`update_mods.ps1`**: The main PowerShell script.
* **`config.psd1`**: Configuration file for Windows.
* **Tools used**: WinSCP and PowerShell.

### Linux (`linux/`)
* **`update_mods.sh`**: The main Bash script.
* **`config.conf`**: Configuration file for Linux.
* **Tools used**: `lftp` and Bash.

Both scripts execute the `ModsUpdater` tool to get the latest mods and then synchronize them to a remote FTP server.

## Getting Started

Follow these steps to set up and use the mod update script.

### Prerequisites

1.  **ModsUpdater**: Ensure you have the **ModsUpdater** program on your computer.
2.  **FTP Client**:
    *   **Windows**: Install **WinSCP**.
    *   **Linux**: Install **`lftp`** (e.g., `sudo apt install lftp`).

### Configuration (Windows)

1.  Open **`windows/config.psd1`**.
2.  Modify the values:
    * `ModsupdaterPath`: The full path to the `VS_ModsUpdater.exe` file.
    * `LocalModsFolder`: The local path to the folder where Modsupdater will update your mods.
    * `WinscpPath`: The full path to the `WinSCP.com` file.
    * FTP credentials and paths.

### Configuration (Linux)

1.  Open **`linux/config.conf`**.
2.  Modify the values:
    * `MODS_UPDATER_PATH`: Path to the executable or `dotnet` command.
    * `LOCAL_MODS_FOLDER`: Local path for mods.
    * FTP credentials and paths.
3.  Make the script executable:
    ```bash
    chmod +x linux/update_mods.sh
    ```

### Running the Script

**Windows:**
1.  Right-click on **`windows/update_mods.ps1`**.
2.  Select **"Run with PowerShell"**.

**Linux:**
1.  Open a terminal.
2.  Run the script:
    ```bash
    ./linux/update_mods.sh
    ```

---

## Compatibility

* **Windows**: Requires PowerShell and WinSCP.
* **Linux**: Requires Bash and lftp.

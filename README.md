# Vintage Story Server Utilities

A collection of utility scripts for managing a Vintage Story server. This repository includes tools for automating mod updates, file synchronization, and other common server maintenance tasks. Scripts are provided for various operating systems, including Windows (PowerShell) and Linux (Bash).

## Files and Scripts

This project is composed of two main files that work together to automate the update process.

* **[update_mods.ps1](update_mods.ps1)**
    This is the main PowerShell script. It orchestrates the entire mod update and deployment process. The script reads all necessary configurations from `config.psd1`, executes the `Modsupdater` tool to get the latest mods, and then uses WinSCP to synchronize the updated files to a remote FTP server.

* **[config.psd1](config.psd1)**  
    This file is the script's configuration file. It stores all user-specific settings, including file paths, application arguments, and FTP credentials. This separation ensures that the main script remains clean and that sensitive information is managed in a single, dedicated location. **Note:** All user configurations must be defined within the `@{} `hashtable.

## Getting Started

Follow these steps to set up and use the mod update script.

### Prerequisites

1.  Ensure you have the **Modsupdater** program (`VS_ModsUpdater.exe`) on your computer. You can find it on the project's page.
2.  Install **WinSCP**. You can download it from the official WinSCP website.

### Configuration

1.  Download the `update_mods.ps1` and `config.psd1` files into the same folder on your computer.
2.  Open the **`config.psd1`** file with a text editor.
3.  Modify the value for each variable to match your specific setup:
    * `ModsupdaterPath`: The full path to the `VS_ModsUpdater.exe` file.
    * `ModsupdaterArguments`: Any additional command-line arguments you want to pass to Modsupdater (separate them with a space).
    * `LocalModsFolder`: The path to the folder where Modsupdater will update your mods.
    * `WinscpPath`: The full path to the `WinSCP.com` file.
    * `FtpUsername` and `FtpPassword`: Your FTP server login credentials.
    * `FtpServer`: Your FTP server address.
    * `RemoteModsPath`: The path to the mods folder on your FTP server.
4.  Save the changes and close the file.

### Running the Script

1.  Right-click on the **`update_mods.ps1`** file.
2.  Select **"Run with PowerShell"**.

The script will run, update your mods locally, and then upload them to your server. A confirmation message will appear in the console once the operation is complete.

---

## Compatibility

This script is designed for **Windows** operating systems and requires **PowerShell** to be enabled. It uses Windows-specific tools like WinSCP.

* For **Linux** or **macOS** users, you can adapt the logic of this script to create a compatible version using **Bash** and a command-line FTP client like `lftp`.

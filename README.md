A collection of utility scripts for managing a Vintage Story server with ModsUpdater. This repository includes tools for automating mod updates, file synchronization.

- **config.psd1**  
This file is the script's configuration file. It stores all user-specific settings, including file paths, application arguments, and FTP credentials. This separation ensures that the main script remains clean and that sensitive information is managed in a single, dedicated location. **Note:** All user configurations must be defined within the `@{} `hashtable.

- **update_mods.ps1**  
This is the main PowerShell script. It orchestrates the entire mod update and deployment process. The script reads all necessary configurations from `config.psd1`, executes the `Modsupdater` tool to get the latest mods, and then uses WinSCP to synchronize the updated files to a remote FTP server.

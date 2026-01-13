# =========================================================================
# Vintage Story Mod Updater Configuration
# This file contains all the settings for the mod update script.
# =========================================================================

@{
    # --- TEST SETTINGS ---
    # Set to $true to simulate the update locally without FTP. Set to $false for production.
    TestMode = $true
    # Local directory that will act as your "Remote Server" (only used if TestMode is $true).
    LocalMockRemotePath = 'E:\Game\Vintage Story\Test script FTP\remote_simulation'

    # --- MODS UPDATER SETTINGS ---
    # Path to the Modsupdater.exe on your computer.
    ModsupdaterPath = 'E:\Game\Vintage Story\_Scripts exe\VS_ModsUpdater_v2_VS.v.1.20.12\VS_ModsUpdater.exe'

    # Arguments to pass to Modsupdater.
    # To add multiple arguments, separate them with a space inside the quotes.
    # Example: '--no-pause --no-pdf'
    ModsupdaterArguments = '--no-pause'

    # Temporary local folder where mods will be downloaded and updated.
    LocalModsFolder = "E:\Game\Vintage Story\Test script FTP\mods"

    # --- FTP SERVER SETTINGS (Ignored if TestMode is $true) ---
    # WinSCP.com executable path.
    WinscpPath = 'C:\Program Files (x86)\WinSCP\WinSCP.com'

    # FTP server credentials.
    FtpUsername = 'your_ftp_username'
    FtpPassword = 'your_ftp_password'

    # FTP server address and remote mods folder path.
    FtpServer = 'your_ftp_server.com'
    RemoteModsPath = '/path/to/your/mods/folder'
}
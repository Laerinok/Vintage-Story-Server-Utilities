# =========================================================================
# Vintage Story Mod Updater Configuration
# This file contains all the settings for the mod update script.
# =========================================================================

# --- MODS UPDATER SETTINGS ---
# Path to the Modsupdater AppImage on your computer.
ModsupdaterPath='/home/user/path/to/VS_ModsUpdater.AppImage'

# Arguments to pass to Modsupdater.
# To add multiple arguments, separate them with a space inside the quotes.
# Example: '--no-pause --no-pdf'
ModsupdaterArguments='--no-pause'

# Temporary local folder where mods will be downloaded and updated.
LocalModsFolder="/home/user/vs-server/mods"

# --- FTP SERVER SETTINGS ---
# lftp executable path.
LftpPath='/usr/bin/lftp'

# FTP server credentials.
FtpUsername='your_ftp_username'
FtpPassword='your_ftp_password'

# FTP server address and remote mods folder path.
FtpServer='your_ftp_server.com'
RemoteModsPath='/path/to/your/mods/folder'
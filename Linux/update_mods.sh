#!/bin/bash

# =========================================================================
# Vintage Story Mod Update Script
# This script reads settings from a configuration file to update mods
# locally and then transfer them to an FTP server using lftp.
# =========================================================================

# --- ANSI COLORS FOR OUTPUT ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- SCRIPT EXECUTION ---
# Get the script's directory and the path to the configuration file.
scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
configPath="$scriptPath/config.sh"

# Check if the configuration file exists.
if [[ ! -f "$configPath" ]]; then
    echo -e "${RED}Error: The configuration file 'config.sh' was not found in the same folder.${NC}"
    echo -e "${RED}Please create the file and fill in your settings.${NC}"
    exit 1
fi

# Load the configuration data.
echo -e "${CYAN}Loading settings from the configuration file...${NC}"
try_load_config() {
    source "$configPath"
}

if ! try_load_config; then
    echo -e "${RED}An error occurred while reading the configuration file. Please check its content.${NC}"
    exit 1
fi

echo -e "${CYAN}Hello! Let's start updating your mods...${NC}"

# 1. Prepare the local folder
echo -e "Step 1/3: Preparing the local mods folder..."

# We will not delete the folder, as Modsupdater handles this.
# We will only create the folder if it does not exist.
if [[ ! -d "$LocalModsFolder" ]]; then
    echo -e "${YELLOW}The folder was not found. Creating it now...${NC}"
    mkdir -p "$LocalModsFolder"
fi

# 2. Execute Modsupdater
echo -e "Step 2/3: Updating mods with Modsupdater..."
execute_modsupdater() {
    # Get the directory of the executable using dirname.
    modsupdaterDirectory=$(dirname "$ModsupdaterPath")

    # Build the argument list.
    arguments="$ModsupdaterArguments --modspath \"$LocalModsFolder\""

    # Start the process from the correct working directory.
    # We use the directory we just extracted.
    chmod +x "$ModsupdaterPath"
    cd "$modsupdaterDirectory" || return 1
    eval "$ModsupdaterPath $arguments"
}

if ! execute_modsupdater; then
    echo -e "${RED}An error occurred while running Modsupdater. Please check the path in your config file.${NC}"
    exit 1
fi

# 3. FTP Synchronization with lftp
# =========================================================================
echo -e "Step 3/3: Sending updated mods to the FTP server..."
execute_ftp_sync() {
    # Create a temporary file for the lftp script.
    # lftp's 'mirror -R' command will synchronize the local mods to the remote server.
    scriptContent="
set sftp:auto-confirm yes
set net:timeout 10
open -u $FtpUsername,$FtpPassword $FtpServer
mirror -R --delete --verbose \"$LocalModsFolder\" \"$RemoteModsPath\"
close
exit
"
    tempScript=$(mktemp)
    echo "$scriptContent" > "$tempScript"

    # Execute lftp using the temporary script
    "$LftpPath" -f "$tempScript"
    
    # Capture exit code
    local exit_status=$?
    
    # Cleanup
    rm -f "$tempScript"
    
    return $exit_status
}

if ! execute_ftp_sync; then
    echo -e "${RED}An error occurred during FTP synchronization. Check your connection and server information in the config file.${NC}"
    exit 1
fi

echo -e "${GREEN}Update completed successfully! Your mods are up to date on the server.${NC}"
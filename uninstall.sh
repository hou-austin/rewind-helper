#!/bin/zsh

# Unload the launchd job
launchctl unload $HOME/Library/LaunchAgents/com.austinhou.rewindhelper.plist

# Remove the script files
sudo rm -rf /usr/local/bin/rewind_helper

# Remove the plist file
rm $HOME/Library/LaunchAgents/com.austinhou.rewindhelper.plist

# Remove log files
sudo rm /var/log/rewind_helper/script.log
sudo rm /var/log/rewind_helper/error.log

echo "Uninstallation complete."

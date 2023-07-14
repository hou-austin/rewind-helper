#!/bin/zsh

# Compile the C file
gcc -Wall -o rewind_helper rewind_helper.c

# Create the directory to store the script and compiled file
sudo mkdir -p /usr/local/bin/rewind_helper

# Copy the compiled file and shell script to /usr/local/bin/rewind_helper
sudo cp rewind_helper /usr/local/bin/rewind_helper/
sudo cp rewind_helper.sh /usr/local/bin/rewind_helper/

# Make the shell script executable
sudo chmod +x /usr/local/bin/rewind_helper/rewind_helper.sh

# Copy the plist file to the appropriate location
mkdir -p $HOME/Library/LaunchAgents
cp com.austinhou.rewindhelper.plist $HOME/Library/LaunchAgents/

# Create log files
sudo mkdir -p /var/log/rewind_helper
sudo touch /var/log/rewind_helper/script.log
sudo touch /var/log/rewind_helper/error.log
sudo chmod 666 /var/log/rewind_helper/script.log
sudo chmod 666 /var/log/rewind_helper/error.log

# Load the launchd job
sudo -u $USER launchctl load $HOME/Library/LaunchAgents/com.austinhou.rewindhelper.plist

echo "Installation complete."

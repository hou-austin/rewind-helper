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

# Dyanmically set plist file
username=$(whoami)
plist_path="./com.austinhou.rewindhelper.plist"
plist_content="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
    <key>Label</key>
    <string>com.austinhou.rewindhelper</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/rewind_helper/rewind_helper</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StartCalendarInterval</key>
    <array>
        <dict>
            <key>Hour</key>
            <integer>16</integer>
            <key>Minute</key>
            <integer>22</integer>
        </dict>
    </array>
    <key>StandardOutPath</key>
    <string>/var/log/rewind_helper/script.log</string>
    <key>StandardErrorPath</key>
    <string>/var/log/rewind_helper/error.log</string>
    <key>UserName</key>
    <string>${username}</string>
</dict>
</plist>"

echo "${plist_content}" > "${plist_path}"

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

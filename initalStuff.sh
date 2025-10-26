#!/bin/bash
T="$(date +%s)"

echo "Starting Program."
the_path="/etc/login.defs"
 

# Editing the Max, Min, and Warn Days for Passwords
echo "Editing DAYS"
sed -i 's/PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' $the_path
sed -i 's/PASS_MIN_DAYS.*/PASS_MIN_DAYS   10/' $the_path
sed -i 's/PASS_WARN_DAYS.*/PASS_WARN_DAYS   7/' $the_path
 

# Making sure OS logs fail and ok logins.
echo "Editing Logs"
sed -i 's/LOG_UNKFAIL_ENAB.*/LOG_UNKFAIL_ENAB   yes/' $the_path
sed -i 's/LOG_OK_LOGINS.*/LOG_OK_LOGINS   yes/' $the_path
 
# Installing/Updating Firewall
echo "Installing Firewall"
apt install ufw
ufw enable

# Updating
#apt update
#apt upgrade

# Scanning for Non-Work Related Media Files
echo "Scanning for Media Files"
users="/home"

touch "results.txt"
file="results.txt"

find /home -type f -iname \*.txt -o -iname \*.mpg -o -iname \*.mp2 -o -iname \*.mpeg -o -iname \*.mpe -o -iname \*.mpv -o -iname \*.ogg -o -iname \*.mp4 -o -iname \*.m4p -o -iname \*.m4v -o -iname \*.avi -o -iname \*.wmv -o -iname \*.mov -o -iname \*.qt -o -iname \*.flv -o -iname \*.swf -o -iname \*.avchd -o -iname \*.mp3 -o -iname \*.aac -o -iname \*.flac -o -iname \*.webm -o -iname \*.jpeg -o -iname \*.tiff -o -iname \*.bmp -o -iname \*.pdf -o -iname \*.png -o -iname \*.gif -o -iname \*.svg -o -iname \*.webp >> $file

echo "Logged to file $file, in the same directory as the script."
T="$(($(date +%s)-T))"
echo "It took ${T} seconds to run this."
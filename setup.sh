#!/bin/bash

secure_password="P1]+}@>A59;G0r%lFdeo"
admin_group="sudo"

# Functions
function confirm() {
	read -p "Are you sure you would like to execute this command? (y = yes, n = no) (BLANK RESPONSES WILL BE NO)" answer
	
	if [ "$answer" == "y" ]; then
		return 1
	fi
}

# Executing Here
echo "|---- Program Started -----|"
echo "Make sure you ran this command using sudo"
echo "WARNING: Make sure the admin group is set correctly. (Default is $admin_group)"

# Users
echo "Section #1 - Users"

awk -F ':' '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd > user.txt

for line in $(cat "user.txt"); do
	echo -e "Choose Options for\033[1m $line \033[0m"
	echo "Nothing = Move on"
	echo "1 = Delete User"
	echo "2 = Secure Password"
	echo "3 = Unadmin User"
	echo "4 = Admin User"
	
	read -p "What do you want to do to $line" response
	
	if [ confirm() == 1 ]; then
		# Statements
		if [ "$response" == "1" ]; then
			# Delete User
			deluser -r $response sudo
			echo "$line Deleted"
		elif [ "$response" == "2" ]; then
			# Secure Password
			chpasswd <<<"$line:$secure_password"
			echo "$line Password's Adjusted"
		elif [ "$response" == "3" ]; then
			# Unadmin User
			gpasswd -d $line $admin_group
			echo "$line Unadmined"
		elif [ "$response" == "4" ]; then
			# Admin User
			useradd -G $admin_group $line
			echo "$line Admined"
		fi
	fi
	
	echo "|----------------------|"
done

the_path="/etc/login.defs"

# install pam crack lib

echo "Configuring Password Settings"
sed -i 's/PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' $the_path
sed -i 's/PASS_MIN_DAYS.*/PASS_MIN_DAYS   10/' $the_path
sed -i 's/PASS_WARN_DAYS.*/PASS_WARN_DAYS   7/' $the_path

echo "|----------------------|"

echo "Logging Logins"
sed -i 's/LOG_UNKFAIL_ENAB.*/LOG_UNKFAIL_ENAB   yes/' $the_path
sed -i 's/LOG_OK_LOGINS.*/LOG_OK_LOGINS   yes/' $the_path

echo "|----------------------|"

echo "Installing & Updating the Firewall"
apt install ufw
ufw enable

echo "|----------------------|"

echo "Scanning for Media Files"
users="/home"

touch "results.txt"
file="results.txt"

find /home -type f -iname \*.txt -o -iname \*.mpg -o -iname \*.mp2 -o -iname \*.mpeg -o -iname \*.mpe -o -iname \*.mpv -o -iname \*.ogg -o -iname \*.mp4 -o -iname \*.m4p -o -iname \*.m4v -o -iname \*.avi -o -iname \*.wmv -o -iname \*.mov -o -iname \*.qt -o -iname \*.flv -o -iname \*.swf -o -iname \*.avchd -o -iname \*.mp3 -o -iname \*.aac -o -iname \*.flac -o -iname \*.webm -o -iname \*.jpeg -o -iname \*.tiff -o -iname \*.bmp -o -iname \*.pdf -o -iname \*.png -o -iname \*.gif -o -iname \*.svg -o -iname \*.webp >> $file

echo "Media files have been logged in /results.txt"

echo "|----------------------|"

echo "Configuring Auto Updates"
apt-get update
apt-get upgrade

echo "|----------------------|"

echo "Securing SSH"
read -p "Is SSH an essential service? (y = yes, n = no) (BLANK RESPONSES WILL BE NO)" allowSSH

if [ "$allowSSH" == "y" ]; then
	sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
	# include additional permissions required to secure ssh.
fi

echo "|----------------------|"

echo "Process completed. Next steps:"
echo "Secure Pam"
echo "Delete guest users and uuid=0"
echo "Remove unneeded programs"
echo "Check logged files in /results.txt"
echo "sudo apt-get install libpam-cracklib"
echo "IF LIGHTDM IS INSTALLED THEN Remove line with autologin-user AND Add the following line to disable guest account: allow_guest=false"

echo "Checklists"
echo "https://www.cochise.edu/wp-content/uploads/2021/02/Security-Checklist-Linux.pdf"
echo "https://github.com/Abdelgawadg/cyberpatriot-checklist-ubuntu"
echo "https://gist.github.com/bobpaw/a0b6828a5cfa31cfe9007b711a36082f"

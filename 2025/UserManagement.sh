#!/bin/bash

secure_password="P1]+}@>A59;G0r%lFdeo"

echo "User Management"

awk -F ':' '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd > user.txt

for line in $(cat "user.txt"); do
	echo -e "Choose Options for\033[1m $line \033[0m"
	echo "Nothing = Skip | 1 = Delete User | 2 = Secure Password | 3 = Unadmin | 4 Admin User"
	
	echo "What do you want to do to $line?"
    read -p "> " response

    case "$response" in
        1 )
            sudo deluser $line
            echo "Deleted $line"
            ;;
        2 )
            echo "$line:$secure_password" | sudo chpasswd
            echo "Password Adjusted for $line"
            ;;
        3 )
            sudo deluser $line sudo
            echo "$line Unadmined"
            ;;
        4)
            sudo usermod -aG sudo $line
            echo "$line Admined"
            ;;
    esac

	echo "|----------------------|"
done

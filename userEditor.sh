#!/bin/bash
T="$(date +%s)"
#1 Get all the users
#2 Loop through all users
#3 Prompt the adminstrator if they should have this user on the system
#4 If yes delete, if no dont

# awk -F '($3>1000)&&($1!="nobody"){print $1}' /etc/passwd

# read: read -p "enter age" age


echo "DELETING/MANAGING USERS ON SYSTEM"
echo "---------------------------------"
echo "Make sure you have answered the forensic questions before doing anything here as you could probably mess up everything and restart"
echo "---------------------------------"


sudo awk -F ':' '($3>1000)&&($1!="nobody"){print $1}' /etc/passwd > user.txt

for line in $(cat "user.txt"); do
    read -p "is $line NOT suppose to be on this system" response
    if [ "$response" == "y" ]; then
        userdel -r $line
    fi
done

echo "---------------------------------"
echo "Edit Admin Privilages"
echo "---------------------------------"

grep -ir sudo /etc/group > admin.txt

for line $(cat "admin.txt"); do
    read -p "is $line NOT suppose to be an admin" response
    if [ "$response" == "y" ]; then
        deluser -r $response sudo
    fi
done


echo "---------------------------------"
echo "Add Admins"
echo "---------------------------------"

echo "code this"

echo "---------------------------------"
echo "Add Users"
echo "---------------------------------"

echo "code this"

T="$(($(date +%s)-T))"
echo "It took ${T} seconds to run this."

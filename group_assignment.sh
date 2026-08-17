#!/bin/bash
# This script facilitates accounts'access assignment.

again="y"

while [ "$again" == "y" ]; do
    read -p "What is the username? " username
    read -p "What group should this user be added to? " group

    usermod -aG "$group" "$username"

    echo "$username has been added to $group"

    read -p "Add another? (y/n) " again
done

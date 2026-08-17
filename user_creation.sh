#!/bin/bash
# This script automates users'creation 

read -p "What is the username? " username

if grep -q "^$username:" /etc/passwd; then
    echo "This username already exists"
else
    useradd -m "$username"
    passwd "$username"
    echo "The user $username has been successfully created"
fi


#!/bin/bash

# Prompt for user.name and user.email
read -p "Enter your Git user.name: " git_name
read -p "Enter your Git user.email: " git_email

# Set up global Git configuration
git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global rerere.enabled true
git config --global merge.tool vimdiff
git config --global merge.conflictstyle diff3
git config --global mergetool.prompt false
git config --global help.autocorrect prompt

echo "Git configuration has been updated."

# Ask if the user wants to generate an SSH key
read -p "Do you want to generate an SSH key pair? (y/n): " generate_ssh

if [[ $generate_ssh == "y" || $generate_ssh == "Y" ]]; then
    ssh-keygen -t rsa -b 4096 -C "$git_email"
    echo "SSH key generated. You can find it in ~/.ssh/id_rsa.pub"

    # Optionally, display the SSH key
    cat ~/.ssh/id_rsa.pub

    echo "You can now add this SSH key to your Git provider."
else
    echo "SSH key generation skipped."
fi

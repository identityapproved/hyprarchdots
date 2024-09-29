#!/bin/bash

# Script to install Doom Emacs on Arch Linux

# Install necessary packages
sudo yay -S --needed emacs ripgrep git multimarkdown shellcheck

# Check if .emacs.d exists and remove it
if [ -d "$HOME/.emacs.d" ]; then
    echo "Removing existing .emacs.d directory..."
    rm -rf "$HOME/.emacs.d/"
fi

# Clone Doom Emacs repository
echo "Cloning Doom Emacs..."
git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.emacs.d"

# Navigate to the Doom Emacs directory
cd "$HOME/.emacs.d" || { echo "Failed to enter the Doom Emacs directory"; exit 1; }

# Run Doom installation
echo "Running Doom installation..." | lolcat -af
./bin/doom install

# Check for issues with Doom installation
echo "Running Doom doctor..."
./bin/doom doctor

echo "Doom Emacs installation complete!" | lolcat -af

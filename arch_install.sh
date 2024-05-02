#!/bin/bash

# Function to install yay if not already installed
install_yay() {
  if ! command -v yay >/dev/null 2>&1; then
    echo "yay is not installed. Installing yay first."

    # Install yay
    sudo pacman -S --noconfirm --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

    # Check if the installation was successful
    if ! command -v yay >/dev/null 2>&1; then
      echo "Error: Unable to install yay. Exiting."
      exit 1
    fi
  fi
}

# Function to prompt user for installation
ask_install() {
  read -rp "Do you want to install $1? (y/N): " response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    yay -S --noconfirm "$1"
  else
    echo "$1 not installed."
  fi
}

# Check if the system is Arch Linux
if [ -f "/etc/arch-release" ]; then
  echo "System is Arch Linux."

  # Install yay if not already installed
  install_yay

else
  echo "Error: This script is intended for Arch Linux. Exiting."
  exit 1
fi

# Install tools from list_tools.txt
while read -r tool; do
  yay -S --noconfirm "$tool"
done < main_tools.txt

# Install optional tools with user confirmation
# while read -r optional_tool; do
#   ask_install "$optional_tool"
# done < optional_list_tools.txt

# Install NVM
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
# nvm install node
# nvm use node

# Check and install cargo (Rust)
if ! command -v cargo >/dev/null 2>&1; then
  echo "cargo is not installed. Installing cargo. RUSTUP!"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

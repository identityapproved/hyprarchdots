#!/bin/bash

# Function to install yay
install_yay() {
  echo "Installing yay..."
  sudo pacman -S --needed base-devel git --noconfirm
  git clone https://aur.archlinux.org/yay.git
  cd yay || exit 1
  makepkg -si --noconfirm
  cd .. && rm -rf yay
}

# Function to install paru
install_paru() {
  echo "Installing paru..."
  sudo pacman -S --needed base-devel git --noconfirm
  git clone https://aur.archlinux.org/paru.git
  cd paru || exit 1
  makepkg -si --noconfirm
  cd .. && rm -rf paru
}

# Function to prompt user for yay or paru installation
choose_helper() {
  echo "Neither yay nor paru is installed."
  read -rp "Which AUR helper would you like to install? (yay/paru): " choice
  case "$choice" in
    yay) install_yay ;;
    paru) install_paru ;;
    *)
      echo "Invalid choice. Exiting."
      exit 1
      ;;
  esac
}

# Check if yay or paru is installed, and install if necessary
check_aur_helper() {
  if command -v yay >/dev/null 2>&1; then
    echo "yay is already installed."
    AUR_HELPER="yay"
  elif command -v paru >/dev/null 2>&1; then
    echo "paru is already installed."
    AUR_HELPER="paru"
  else
    choose_helper
    # Set the installed helper
    if command -v yay >/dev/null 2>&1; then
      AUR_HELPER="yay"
    elif command -v paru >/dev/null 2>&1; then
      AUR_HELPER="paru"
    else
      echo "Error: Failed to install an AUR helper. Exiting."
      exit 1
    fi
  fi
}

# Check if the system is Arch Linux
if [ -f "/etc/arch-release" ]; then
  echo "System is Arch Linux."
else
  echo "Error: This script is intended for Arch Linux. Exiting."
  exit 1
fi

# Ensure an AUR helper is installed
check_aur_helper

# Install tools from list_tools.txt
while read -r tool; do
  "$AUR_HELPER" -S --noconfirm "$tool"
done < list_tools.txt

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

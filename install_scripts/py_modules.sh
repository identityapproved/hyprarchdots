#!/bin/bash

# List of packages to install
packages=(
  "python"
  "python-pip"
  "python-libtmux"
  "python-pynvim"
  "python-pytest"
  "pyinstaller"
)

# Function to install package using yay
install_package() {
  sudo yay -S --noconfirm "$1" || { echo "Failed to install $1. Exiting." >&2; exit 1; }
}

# Install each package
for pkg in "${packages[@]}"; do
  install_package "$pkg"
done

echo "All specified Python packages have been installed successfully." | lolcat -af

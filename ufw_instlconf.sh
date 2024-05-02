#!/bin/bash

# Install ufw if not installed
if ! command -v yay >/dev/null 2>&1; then
  echo "yay not found. Installing ufw using pacman..."
  pacman -S --noconfirm ufw
else
  if ! yay -Qi ufw >/dev/null 2>&1; then
    echo "Installing ufw using yay..."
    yay -S --noconfirm ufw
  fi
fi

# Disable ufw if it's enabled
ufw disable

# Reset all firewall rules
ufw --force reset

# Set firewall rules
ufw limit 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw default deny incoming
ufw default allow outgoing

# Enable ufw
ufw enable

# List all firewall rules
ufw status verbose

#!/bin/bash

# Install ufw if not installed
# add checkings and install


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

# Block CUPS ports (typically 631 TCP and UDP)
ufw deny 631/tcp
ufw deny 631/udp

# Enable ufw
ufw enable

# List all firewall rules
ufw status verbose

# Check if CUPS is enabled
if systemctl is-active --quiet cups.service; then
  echo "CUPS is currently enabled."
  echo "To disable CUPS, run: sudo systemctl disable --now cups.service"
else
  echo "CUPS is currently disabled."
fi

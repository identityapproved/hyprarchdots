#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install packages
install_packages() {
    if command_exists yay; then
        yay -S --needed --noconfirm "$@"
    else
        sudo pacman -S --needed --noconfirm "$@"
    fi
}

if ! pacman -Qi iptables-nft &>/dev/null; then
    (echo "The iptables-nft package is not installed on your system." && \
      echo "This package is required for virt-manager." && \
      echo "Please manually install iptables-nft before running this script:" && \
      echo "sudo pacman -S iptables-nft" && \
      echo "If you have the regular iptables package installed, you may need to remove it first:" && \
      echo "sudo pacman -R iptables" && \
      echo "Then install iptables-nft and run this script again.") | lolcat -af
    exit 1
fi
# Check for iptable

# Update system
echo "Updating system..."
if command_exists yay; then
    yay -Syu --noconfirm
else
    sudo pacman -Syu --noconfirm
fi

# Install virt-manager and dependencies
echo "Installing virt-manager and dependencies..." | lolcat -af
install_packages virt-manager qemu vde2 ebtables nftables dnsmasq bridge-utils ovmf

# Enable and start libvirtd service
echo "Enabling and starting libvirtd service..." | lolcat -af
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

# Configure libvirtd.conf
echo "Configuring libvirtd.conf..." | lolcat -af
sudo sed -i 's/^#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/' /etc/libvirt/libvirtd.conf
sudo sed -i 's/^#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf

# Configure network.conf
echo "Configuring network.conf..." | lolcat -af
sudo sed -i 's/^#firewall_backend = "nftables"/firewall_backend = "iptables"/' /etc/libvirt/network.conf

# Enable iptables service
echo "Enabling iptables service..." | lolcat -af
sudo systemctl enable iptables.service
sudo systemctl start iptables.service

# Add user to libvirt group
echo "Adding current user to libvirt group..." | lolcat -af
sudo usermod -aG libvirt $USER

(echo "Installation complete!" && echo "Please log out and log back in for group changes to take effect." && echo "You can then start virt-manager by running 'virt-manager' in the terminal.") | lolcat -af

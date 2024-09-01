#!/bin/bash

# Check if BlackArch repository is already added
if ! grep -q "\[blackarch\]" /etc/pacman.conf; then
    echo "BlackArch repository not found. Adding it now..."

    # Download the strap.sh script
    curl -O https://blackarch.org/strap.sh

    # Verify the SHA1 sum
    if echo "26849980b35a42e6e192c6d9ed8c46f0d6d06047 strap.sh" | sha1sum -c -; then
        echo "SHA1 sum verified."

        # Set execute bit
        chmod +x strap.sh

        # Run the script as root
        sudo ./strap.sh

        # Enable multilib if not already enabled
        if ! grep -q "\[multilib\]" /etc/pacman.conf; then
            echo "Enabling multilib..."
            sudo sed -i '/#\[multilib\]/,/#Include/ s/^#//' /etc/pacman.conf
            sudo pacman -Syu
        fi

        echo "BlackArch repository has been successfully added."
    else
        echo "SHA1 sum verification failed. Exiting."
        exit 1
    fi
else
    echo "BlackArch repository is already added."
fi

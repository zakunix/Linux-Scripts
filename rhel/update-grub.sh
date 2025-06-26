#!/bin/bash

################################################################################
# GRUB2 Configuration Updater Script
# Created by: Zakir
# Optimized and beautified by ChatGPT for improved clarity and UX
################################################################################

# Ensure the script is executed with root privileges
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run this script as root (e.g., using sudo)."
    exit 1
fi

# Step 1: Regenerate GRUB configuration file
echo "[*] Generating new GRUB2 configuration..."
grub2-mkconfig -o /boot/grub2/grub.cfg

# Step 2: Update all kernel entries in GRUB
echo "[*] Updating GRUB kernel entries..."
grubby --update-kernel=ALL

# Step 3: Prompt for reboot
echo
read -p "🔁 Reboot is required for changes to take effect. Press Enter to continue..."

echo "[*] Done."


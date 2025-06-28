#!/bin/bash

################################################################################
# NVIDIA Secure Boot Signing Script
# Created by: Zakir
# Original Source: https://blog.monosoul.dev/2022/05/17/automatically-sign-nvidia-kernel-module-in-fedora-36/
# Optimized and beautified by ChatGPT for clarity and DE compatibility
################################################################################

MARKER_FILE="/tmp/sign_nvidia"
SCRIPT_PATH="$(realpath "$0")"

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run this script as root (sudo)."
    exit 1
fi

# Function to install NVIDIA drivers
install_nvidia() {
    echo "[*] Installing NVIDIA drivers and dependencies..."
    dnf install -y gcc kernel-headers kernel-devel akmod-nvidia \
        xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs \
        xorg-x11-drv-nvidia-libs.i686
}

# Function to resume after reboot
after_reboot() {
    echo "[*] Resuming NVIDIA driver installation..."

    read -p "❓ Do you want to (re)install NVIDIA drivers? [Y/N] " yn
    case $yn in
        [Yy]* ) install_nvidia ;;
        [Nn]* ) echo "[*] Skipping driver installation." ;;
        * ) echo "Invalid input. Exiting."; exit 1 ;;
    esac

    echo "[*] Compiling kernel modules..."
    akmods --force

    echo "[*] Updating boot image..."
    dracut --force

    echo "[*] Cleaning up autostart entry..."
    rm -f "$MARKER_FILE"
    rm -f ~/.config/autostart/sign_nvidia.desktop

    echo "[*] ✅ Installation complete. Please reboot."
    read -p "Press Enter to reboot..."
    reboot
}

# Resume after reboot if marker exists
if [ -f "$MARKER_FILE" ]; then
    after_reboot
    exit 0
fi

# Step 1: Install secure boot tools
echo "[*] Installing tools for Secure Boot support..."
dnf install -y kmodtool akmods mokutil openssl

# Step 2: Generate signing key
echo "[*] Generating signing certificates..."
kmodgenca -a

# Step 3: Enroll the public key using MOK
echo
echo "🔐 You’ll be asked for a password to enroll MOK (Machine Owner Key)."
echo "⚠️  Remember this password; you'll need it after reboot."
read -p "Press Enter to continue..."

mokutil --import /etc/pki/akmods/certs/public_key.der

# Step 4: Mark to continue after reboot
touch "$MARKER_FILE"

# Step 5: Detect available terminal emulator
get_terminal_launcher() {
    for term in gnome-terminal konsole xfce4-terminal xterm lxterminal mate-terminal; do
        if command -v "$term" >/dev/null 2>&1; then
            echo "$term -- bash -c '$SCRIPT_PATH'"
            return
        fi
    done
    echo "xterm -e bash '$SCRIPT_PATH'"  # Fallback
}

# Step 6: Create cross-DE autostart entry
mkdir -p ~/.config/autostart
cat <<EOF > ~/.config/autostart/sign_nvidia.desktop
[Desktop Entry]
Type=Application
Exec=$(get_terminal_launcher)
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Continue NVIDIA Sign
Comment=Resume NVIDIA signing after reboot
EOF

chmod +x "$SCRIPT_PATH"

# Step 7: Prompt for reboot
echo "[*] 🔁 Reboot required to enroll the MOK key and continue installation."
read -p "Press Enter to reboot..."
reboot

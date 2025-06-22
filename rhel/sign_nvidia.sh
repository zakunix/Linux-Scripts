#!/bin/bash

# Path to marker file used to determine whether we are continuing after a reboot
MARKER_FILE="/tmp/sign_nvidia"
SCRIPT_PATH="$(realpath "$0")"

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run this script as root (sudo)."
    exit 1
fi

# Function to continue the driver installation after reboot
after_reboot() {
    echo "[*] Continuing signing and installing of NVIDIA drivers..."

    echo "[*] Installing NVIDIA drivers and dependencies..."
    dnf install -y gcc kernel-headers kernel-devel akmod-nvidia \
        xorg-x11-drv-nvidia xorg-x11-drv-nvidia-libs xorg-x11-drv-nvidia-libs.i686

    echo "[*] Compiling kernel modules..."
    akmods --force

    echo "[*] Updating boot image..."
    dracut --force

    echo "[*] Cleaning up..."
    rm -f "$MARKER_FILE"
    rm -f ~/.config/autostart/sign_nvidia.desktop

    echo "[*] ✅ NVIDIA drivers installed successfully."
    echo "[*] 🔁 Please reboot to apply changes."

    read -p "Press Enter to reboot..."
    reboot
}

# Check if we're continuing after a reboot
if [ -f "$MARKER_FILE" ]; then
    after_reboot
fi

# Step 1: Install required tools
echo "[*] Installing required tools for secure boot and driver signing..."
dnf install -y kmodtool akmods mokutil openssl

# Step 2: Generate kernel module signing certificate
echo "[*] Generating module signing certificate..."
kmodgenca -a

# Step 3: Enroll the public key into MOK (Machine Owner Key)
echo
echo "🔐 You will now be prompted to enter a password for MOK enrollment."
echo "⚠️  Please remember this password. You will need it after reboot."
read -p "Press Enter to continue..."

mokutil --import /etc/pki/akmods/certs/public_key.der

# Step 4: Mark for continuation after reboot
touch "$MARKER_FILE"

# Step 5: Add autostart entry to continue after reboot
mkdir -p ~/.config/autostart
cat <<EOF > ~/.config/autostart/sign_nvidia.desktop
[Desktop Entry]
Type=Application
Exec=gnome-terminal -- bash -c '$SCRIPT_PATH'
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Continue NVIDIA Sign
Comment=Continues NVIDIA driver signing process
EOF

# Step 6: Prompt user to reboot for MOK enrollment
echo "[*] Reboot is required to enroll MOK key and continue installation."
read -p "Press Enter to reboot now..."
reboot

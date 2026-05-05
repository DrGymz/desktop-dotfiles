#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/DrGymz/Nixos-Dotfiles.git"
FLAKE_REF="/mnt/etc/nixos#nixos"

echo "=== NixOS Installer ==="
echo ""

if ! command -v git &>/dev/null; then
  echo "Installing git..."
  nix-env -iA nixos.git
fi

lsblk -d -o NAME,SIZE,MODEL
echo ""
read -rp "Enter target disk (e.g. /dev/nvme0n1 or /dev/sda): " DISK

if [[ ! -b "$DISK" ]]; then
  echo "Error: $DISK is not a valid block device."
  exit 1
fi

echo ""
echo "WARNING: This will ERASE ALL DATA on $DISK"
lsblk "$DISK"
echo ""
read -rp "Type 'yes' to continue: " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
  echo "Aborted."
  exit 1
fi

echo ""
echo "[1/7] Partitioning $DISK..."

parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MiB 1GiB
parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart swap linux-swap 1GiB 9GiB
parted "$DISK" -- mkpart root ext4 9GiB 100%

if [[ "$DISK" == *"nvme"* || "$DISK" == *"mmcblk"* ]]; then
  PART1="${DISK}p1"
  PART2="${DISK}p2"
  PART3="${DISK}p3"
else
  PART1="${DISK}1"
  PART2="${DISK}2"
  PART3="${DISK}3"
fi

echo "[2/7] Formatting partitions..."
mkfs.fat -F 32 -n BOOT "$PART1"
mkswap -L SWAP "$PART2"
mkfs.ext4 -L NIXOS "$PART3"

# --- Mounting ---
echo "[3/7] Mounting filesystems..."
mount "$PART3" /mnt
mkdir -p /mnt/boot
mount "$PART1" /mnt/boot
swapon "$PART2"

echo "[4/7] Generating hardware-configuration.nix..."
nixos-generate-config --root /mnt

echo "[5/7] Cloning dotfiles repo..."

cp /mnt/etc/nixos/hardware-configuration.nix /tmp/hw-config.nix

rm -rf /mnt/etc/nixos
git clone "$REPO_URL" /mnt/etc/nixos

cp /tmp/hw-config.nix /mnt/etc/nixos/hardware-configuration.nix

echo "    Cloning dotfiles to /home/asus/dotfiles..."
mkdir -p /mnt/home/asus
git clone "$REPO_URL" /mnt/home/asus/dotfiles

cp /tmp/hw-config.nix /mnt/home/asus/dotfiles/hardware-configuration.nix

echo "[6/7] Running nixos-install (this will take a while)..."
nixos-install --flake "$FLAKE_REF" --no-root-passwd

echo ""
echo "[7/7] Setting passwords..."
echo "--- Set root password ---"
nixos-enter --root /mnt -- passwd root
echo ""
echo "--- Set asus user password ---"
nixos-enter --root /mnt -- passwd asus

nixos-enter --root /mnt -- chown -R asus:users /home/asus/dotfiles

echo ""
echo "=== Installation complete! ==="
echo "You can now reboot into your system."
echo "  1. reboot"
echo "  2. Log in as 'asus'"
echo "  3. Enjoy your system!"

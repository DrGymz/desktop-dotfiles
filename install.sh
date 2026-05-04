#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/DrGymz/Nixos-Dotfiles.git"

echo "=== NixOS Installer ==="
echo ""

if ! command -v git &>/dev/null; then
  echo "Installing git..."
  nix-env -iA nixos.git
fi

echo "Which host are you installing?"
echo "  1) laptop  (ASUS laptop — AMD CPU + NVIDIA hybrid)"
echo "  2) desktop (Desktop PC — Intel CPU + NVIDIA dedicated)"
echo ""
read -rp "Enter choice (1 or 2): " HOST_CHOICE

case "$HOST_CHOICE" in
  1) HOST="laptop" ;;
  2) HOST="desktop" ;;
  *)
    echo "Error: Invalid choice."
    exit 1
    ;;
esac

FLAKE_REF="/mnt/etc/nixos#${HOST}"
echo ""
echo "Installing configuration: $HOST"
echo ""

# --- Disk selection ---
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

# --- Partitioning ---
echo ""
echo "[1/7] Partitioning $DISK..."

parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MiB 1GiB
parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart swap linux-swap 1GiB 9GiB
parted "$DISK" -- mkpart root ext4 9GiB 100%

# Determine partition names (nvme uses p1/p2/p3, sata uses 1/2/3)
if [[ "$DISK" == *"nvme"* || "$DISK" == *"mmcblk"* ]]; then
  PART1="${DISK}p1"
  PART2="${DISK}p2"
  PART3="${DISK}p3"
else
  PART1="${DISK}1"
  PART2="${DISK}2"
  PART3="${DISK}3"
fi

# --- Formatting ---
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

# --- Generate hardware config ---
echo "[4/7] Generating hardware-configuration.nix..."
nixos-generate-config --root /mnt

# --- Clone dotfiles ---
echo "[5/7] Cloning dotfiles repo..."

# Save the generated hardware config
cp /mnt/etc/nixos/hardware-configuration.nix /tmp/hw-config.nix

# Clean out generated config and clone dotfiles
rm -rf /mnt/etc/nixos
git clone "$REPO_URL" /mnt/etc/nixos

# Place the generated hardware config in the correct host directory
cp /tmp/hw-config.nix "/mnt/etc/nixos/hosts/${HOST}/hardware-configuration.nix"

# Flakes only see git-tracked files, so stage the new hardware config
git -C /mnt/etc/nixos add "hosts/${HOST}/hardware-configuration.nix"

# --- Clone dotfiles to user home (for home-manager symlinks) ---
echo "    Cloning dotfiles to /home/asus/dotfiles..."
mkdir -p /mnt/home/asus
git clone "$REPO_URL" /mnt/home/asus/dotfiles

# Copy hardware config to user dotfiles too
cp /tmp/hw-config.nix "/mnt/home/asus/dotfiles/hosts/${HOST}/hardware-configuration.nix"
git -C /mnt/home/asus/dotfiles add "hosts/${HOST}/hardware-configuration.nix"

# --- Install ---
echo "[6/7] Running nixos-install (this will take a while)..."
nixos-install --flake "$FLAKE_REF" --no-root-passwd

# --- Done ---
echo ""
echo "[7/7] Setting passwords..."
echo "--- Set root password ---"
nixos-enter --root /mnt -- passwd root
echo ""
echo "--- Set asus user password ---"
nixos-enter --root /mnt -- passwd asus

# Fix ownership of user dotfiles
nixos-enter --root /mnt -- chown -R asus:users /home/asus/dotfiles

echo ""
echo "=== Installation complete! ==="
echo "You can now reboot into your system."
echo "  1. reboot"
echo "  2. Log in as 'asus'"
echo "  3. Rebuild with: sudo nixos-rebuild switch --flake /etc/nixos#${HOST}"

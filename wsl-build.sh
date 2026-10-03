#!/bin/bash
# GoConsoleOS Linux - WSL build driver
# Wraps live-build with fixes needed on Ubuntu/WSL hosts.
set -e
SRC="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR=/build

echo "[1/5] Host dependencies..."
apt-get install -y -qq live-build live-config live-boot debootstrap xorriso \
  squashfs-tools mtools dosfstools isolinux syslinux syslinux-common pxelinux \
  syslinux-utils genisoimage > /dev/null 2>&1 || true
mkdir -p /usr/lib/syslinux
ln -sf /usr/lib/ISOLINUX/isolinux.bin /usr/lib/syslinux/isolinux.bin
ln -sf /usr/lib/syslinux/modules/bios/vesamenu.c32 /usr/lib/syslinux/vesamenu.c32

# Patch live-build bug: lb_binary_syslinux uses unset ${_SUFFIX} for casper mode
sed -i 's|\${_SUFFIX}/live.cfg|${_TARGET}/live.cfg|g' /usr/lib/live/build/lb_binary_syslinux 2>/dev/null || true

echo "[2/5] Configuring (Ubuntu noble)..."
mkdir -p "$BUILD_DIR"
rm -rf "$BUILD_DIR/config"
cp -r "$SRC/config" "$BUILD_DIR/"
cd "$BUILD_DIR"
lb config --distribution noble --architectures amd64 --binary-images iso-hybrid \
  --archive-areas "main restricted universe multiverse" \
  --parent-archive-areas "main restricted universe multiverse" \
  --syslinux-theme goconsole \
  --iso-application "GoConsoleOS" --iso-publisher "GoStudios Corporation" \
  --iso-volume "GoConsoleOS-1.0" \
  --apt-indices false --apt-recommends true --apt-source-archives false \
  --firmware-binary false --firmware-chroot false --memtest false \
  --security false --backports false --clean 2>&1 | tail -1

echo "[3/5] Building (30-60 min)..."
lb build > build.log 2>&1 || { tail -20 build.log; exit 1; }

echo "[4/5] Output:"
ls -la "$BUILD_DIR"/*.iso

echo "[5/5] Copy to: $SRC/output/GoConsoleOS-1.0-amd64.iso"
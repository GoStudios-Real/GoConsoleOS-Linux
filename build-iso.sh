#!/bin/bash
# GoConsoleOS Linux ISO Builder
# Builds a custom SteamOS-like gaming OS ISO for VirtualBox
# Usage: sudo ./build-iso.sh [ubuntu|debian]

set -e

DISTRO="${1:-ubuntu}"
LIVE_BUILD_DIR="$(cd "$(dirname "$0")" && pwd)"
ISO_OUTPUT="$LIVE_BUILD_DIR/output"
BUILD_DIR="$LIVE_BUILD_DIR/build"
LB_CONFIG="$LIVE_BUILD_DIR/config"

echo "=========================================="
echo "  GoConsoleOS Linux ISO Builder"
echo "  GoStudios Corporation"
echo "=========================================="
echo ""
echo "Distribution: $DISTRO"
echo "Build dir:    $BUILD_DIR"
echo "Output:       $ISO_OUTPUT"
echo ""

# Check root
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run as root (sudo ./build-iso.sh)"
    exit 1
fi

# Install live-build if needed
if ! command -v lb &> /dev/null; then
    echo "[1/7] Installing live-build..."
    apt-get update -qq
    apt-get install -y -qq live-build live-config live-boot cdebootstrap 2>/dev/null || \
    apt-get install -y -qq live-build live-config 2>/dev/null
fi

# Clean previous build
echo "[2/7] Cleaning previous build..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR" "$ISO_OUTPUT"

cd "$BUILD_DIR"

# Initialize live-build
echo "[3/7] Initializing live-build..."
lb config noauto \
    --distribution "$DISTRO" \
    --archive-areas "main universe multiverse restricted" \
    --architectures amd64 \
    --binary-images iso-hybrid \
    --bootappend-live "boot=live hostname=gostudios username=gostudios quiet splash" \
    --iso-application "GoConsoleOS" \
    --iso-publisher "GoStudios Corporation" \
    --iso-volume "GoConsoleOS-1.0" \
    --grub-locale "en_US" \
    --apt-indices false \
    --apt-recommends true \
    --apt-source-archives false \
    --firmware-binary false \
    --firmware-chroot false \
    --linux-packages "linux-image linux-headers" \
    --memtest false \
    --security false \
    --updates false \
    --backports false \
    --freeze false \
    --clean \
    2>/dev/null || {
        echo "WARNING: lb config failed, trying alternative config..."
        lb config \
            --distribution "$DISTRO" \
            --architectures amd64 \
            --binary-images iso-hybrid \
            --iso-application "GoConsoleOS" \
            --iso-publisher "GoStudios Corporation" \
            --iso-volume "GoConsoleOS-1.0"
    }

# Copy config
echo "[4/7] Copying GoConsoleOS configuration..."
cp -r "$LB_CONFIG"/package-lists "$BUILD_DIR/config/" 2>/dev/null || true
mkdir -p "$BUILD_DIR/config/includes.chroot"
cp -r "$LB_CONFIG"/includes.chroot/* "$BUILD_DIR/config/includes.chroot/" 2>/dev/null || true
mkdir -p "$BUILD_DIR/config/hooks"
cp -r "$LB_CONFIG"/hooks/* "$BUILD_DIR/config/hooks/" 2>/dev/null || true

# Generate wallpapers if missing
echo "[5/7] Generating branding assets..."
bash "$LIVE_BUILD_DIR/generate-assets.sh" 2>/dev/null || echo "WARNING: Asset generation skipped"

# Build ISO
echo "[6/7] Building ISO (this may take 30-60 minutes)..."
echo ""

lb build 2>&1 | tee "$ISO_OUTPUT/build.log" || {
    echo "BUILD FAILED - check $ISO_OUTPUT/build.log"
    exit 1
}

# Copy output
echo ""
echo "[7/7] Build complete!"
ISO_FILE=$(find "$BUILD_DIR" -name "*.iso" -o -name "*.hybrid.iso" 2>/dev/null | head -1)
if [ -n "$ISO_FILE" ]; then
    cp "$ISO_FILE" "$ISO_OUTPUT/GoConsoleOS-1.0-amd64.iso"
    echo ""
    echo "=========================================="
    echo "  ISO Created Successfully!"
    echo "=========================================="
    echo ""
    echo "  File: $ISO_OUTPUT/GoConsoleOS-1.0-amd64.iso"
    echo "  Size: $(du -h "$ISO_OUTPUT/GoConsoleOS-1.0-amd64.iso" | cut -f1)"
    echo ""
    echo "  VirtualBox Setup:"
    echo "  1. Create VM: Type=Linux, Version=Ubuntu (64-bit)"
    echo "  2. RAM: 4096 MB, Video: 128 MB, 3D Acceleration: ON"
    echo "  3. Attach ISO to empty optical drive"
    echo "  4. Boot VM -> Install GoConsoleOS"
    echo ""
else
    echo "ERROR: No ISO found after build"
    echo "Check build log: $ISO_OUTPUT/build.log"
    exit 1
fi

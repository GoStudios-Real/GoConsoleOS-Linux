# GoConsoleOS Linux

**USB-Powered Gaming Console OS** — A SteamOS-like Linux distribution for VirtualBox and PC hardware.

![GoConsoleOS](https://img.shields.io/badge/Version-1.0.0-blue) ![Base](https://img.shields.io/badge/Base-Ubuntu%20%7C%20Debian-orange) ![License](https://img.shields.io/badge/License-MIT-green)

## GoStudios Corporation Gaming OS

GoConsoleOS Linux is a custom gaming-focused Linux distribution inspired by SteamOS 3, branded with the GoStudios theme.

## SteamOS Features Included

| Feature | GoConsoleOS Implementation |
|---------|---------------------------|
| **Gaming Mode** | Steam Big Picture + Gamescope micro-compositor |
| **Desktop Mode** | KDE Plasma with GoConsoleOS theme |
| **Game Launcher** | Steam + Lutris + Flatpak |
| **Proton** | Windows game compatibility (via Steam) |
| **Performance Overlay** | MangoHud (fps, CPU/GPU temp, RAM, frame timing) |
| **GameMode** | Automatic CPU/GPU performance tuning |
| **Controller Support** | Steam Input + udev rules for Xbox/PS/Switch/Nokia |
| **PipeWire** | Modern audio server (like SteamOS) |
| **Shader Pre-caching** | Vulkan shader precompilation via Steam |
| **On-Screen Keyboard** | Custom GoConsoleOS-themed keyboard (Super+K) |
| **Vulkan/Graphics** | Mesa Vulkan drivers + DXVK/VKD3D (via Proton) |
| **Sleep/Suspend** | Console-like sleep with game resume |
| **Flatpak** | Universal app packaging |

## Features

### Custom Branding
- GoConsoleOS logos (SVG + PNG)
- Blue `#0066FF` GoStudios theme throughout
- Custom SDDM login screen
- Custom GRUB boot menu
- Custom wallpaper (blue wave)
- Plymouth boot splash
- Neofetch with GoConsoleOS ASCII art

### Gaming Mode (like SteamOS)
```
Select "GoConsoleOS Gaming Mode" at login
→ Steam Big Picture / Gamescope fullscreen
→ Controller-only navigation
→ Performance overlay (MangoHud)
→ Game library browsing
```

### Desktop Mode (like SteamOS Desktop Mode)
```
Select "GoConsoleOS Desktop Mode" at login
→ KDE Plasma desktop
→ Full Linux desktop experience
→ File manager, terminal, browser
→ Install apps via apt/flatpak
```

### Controller Support
- Xbox One/Series X|S (xpad driver)
- PS4 DualShock 4 (hid-playstation)
- PS5 DualSense (hid-playstation)
- Nintendo Switch Pro (hid-nintendo)
- Nokia MD-11
- Generic Bluetooth gamepads
- Hot-plug detection with notifications
- Steam Input remapping

### On-Screen Keyboard
- Toggle: `Super+K`
- GoConsoleOS blue theme
- Controller-accessible navigation
- Multiple layouts (Extended, Compact)
- onboard + matchbox-keyboard fallback

## Quick Start (Build ISO)

### Option 1: Build on Linux/WSL
```bash
sudo apt-get install live-build live-config
sudo ./build-iso.sh ubuntu
```

### Option 2: Build in Docker
```bash
docker run --rm -v $(pwd):/build ubuntu:24.04 bash -c "
  apt-get update && apt-get install -y live-build
  cd /build && sudo ./build-iso.sh ubuntu
"
```

### Output
```
output/GoConsoleOS-1.0-amd64.iso
```

## VirtualBox Setup

1. **Create VM**
   - Name: `GoConsoleOS`
   - Type: `Linux`
   - Version: `Ubuntu (64-bit)`
   - RAM: `4096 MB`
   - CPU: `2 cores`
   - Video: `128 MB`, 3D Acceleration: ON
   - Storage: `40 GB` dynamically allocated

2. **Attach ISO**
   - Settings → Storage → Empty optical drive
   - Click CD icon → Choose disk file → `GoConsoleOS-1.0-amd64.iso`

3. **Boot**
   - Start VM → Select "GoConsoleOS - Gaming Mode" or "Desktop Mode"

4. **Install** (optional)
   - Select "GoConsoleOS - OEM Install" in boot menu
   - Follow installer → restart → remove ISO

## Project Structure

```
GoConsoleOS-Linux/
├── build-iso.sh                    # Main build script
├── generate-assets.sh              # Wallpaper/logo generator
├── config/
│   ├── package-lists/              # Packages to install
│   ├── includes.chroot/            # Files copied into ISO
│   │   ├── etc/
│   │   │   ├── sddm.conf           # Login screen config
│   │   │   ├── udev/rules.d/       # Controller udev rules
│   │   │   └── skel/               # User skeleton files
│   │   └── usr/share/
│   │       ├── goconsole/
│   │       │   ├── branding/       # Logos + ASCII art
│   │       │   ├── wallpapers/     # Generated wallpapers
│   │       │   ├── keyboard/       # On-screen keyboard
│   │       │   ├── scripts/        # Gaming/Desktop mode
│   │       │   └── themes/         # KDE color scheme
│   │       └── sddm/themes/gostudios/  # Login theme
│   ├── hooks/                      # Build hooks
│   └── bootloaders/grub-pc/        # GRUB boot menu
├── assets/
│   ├── logos/                      # SVG logos
│   └── wallpapers/                 # Source wallpapers
└── docs/
```

## SteamOS Comparison

| Aspect | SteamOS 3 | GoConsoleOS |
|--------|-----------|-------------|
| Base | Arch Linux | Ubuntu/Debian |
| Gaming Mode | Gamescope + Steam | Gamescope + Steam |
| Desktop Mode | KDE Plasma | KDE Plasma |
| Compositor | Gamescope (Wayland) | Gamescope + X11 |
| Package Mgr | pacman + Flatpak | apt + Flatpak |
| Proton | ✅ | ✅ (via Steam) |
| GameMode | ✅ | ✅ |
| MangoHud | ✅ | ✅ |
| Controller | Steam Input | Steam Input + udev |
| On-Screen KB | Steam overlay | Custom GoConsoleOS KB |
| Updates | Atomic A/B | Standard apt |
| Branding | Valve/Steam | GoStudios |

## Packages Installed

- **Desktop**: KDE Plasma, SDDM, Dolphin, Konsole
- **Gaming**: Steam, Lutris, Wine, GameMode, MangoHud
- **Graphics**: Mesa, Vulkan, Xorg
- **Audio**: PipeWire, PulseAudio
- **Controllers**: xpad, hid-playstation, hid-nintendo, xboxdrv
- **Keyboard**: onboard, matchbox-keyboard
- **VirtualBox**: guest-utils, guest-x11, guest-dkms
- **Utilities**: htop, neofetch, git, curl, flatpak, Firefox

## Links

- [GoConsoleOS Windows](https://github.com/GoStudios-Real/GoConsoleOS)
- [GoConsoleOS Android](https://github.com/GoStudios-Real/GoConsoleOS-Android)
- [GoConsoleOS VR](https://github.com/GoStudios-Real/GoConsoleOS-Android-VR)
- [GoConsoleOS Web](https://github.com/GoStudios-Real/GoConsoleOS-Web)
- [SteamOS](https://store.steampowered.com/steamos)
- [Gamescope](https://github.com/ValveSoftware/gamescope)
- [Proton](https://github.com/ValveSoftware/Proton)

## License

MIT License — GoStudios Corporation

## WSL Build (tested path)

The ISO was built successfully on **Windows + WSL2 Ubuntu 26.04** using:

```powershell
wsl --install Ubuntu
wsl -d Ubuntu
sudo bash /mnt/c/Users/RhysC/Downloads/GoConsole/GoConsoleOS-Linux/wsl-build.sh
```

Output: `/build/binary.hybrid.iso` → copy to `output/GoConsoleOS-1.0-amd64.iso`.

### Build notes / live-build fixes applied
- `--archive-areas` **and** `--parent-archive-areas` must include `universe multiverse` (Steam, KDE, MangoHud…).
- Custom syslinux theme `goconsole` (in `config/includes.chroot/usr/share/syslinux/themes/`) with
  `boot=casper` entries — the stock `ubuntu-oneiric` theme and `gfxboot-theme-ubuntu` no longer exist in noble.
- Hook `0600` installs shim packages (`syslinux-themes-goconsole`, `gfxboot-theme-ubuntu`) so
  live-build's `Check_package` (dpkg-based) passes.
- `wsl-build.sh` patches a live-build bug (`${_SUFFIX}` → `${_TARGET}` in `lb_binary_syslinux`).
- Host symlinks: `/usr/lib/syslinux/isolinux.bin` → `/usr/lib/ISOLINUX/isolinux.bin` (Ubuntu path layout).
- Build on the **WSL native filesystem** (`/build`), not `/mnt/c` — tar/debootstrap breaks on 9p mounts.

### ISO status (2026-10-03)
- **Built successfully**: `GoConsoleOS-1.0-amd64.iso` (3.07 GB, hybrid MBR, bootable)
- Contents verified: `/casper/filesystem.squashfs`, kernel `6.8.0-146`, `/isolinux/` boot chain
- BIOS boot only (VirtualBox default) — no UEFI image yet (`LB_BOOTLOADER=syslinux`)
- `config/includes.chroot` carries all GoStudios branding, hooks, udev rules, SDDM theme, scripts

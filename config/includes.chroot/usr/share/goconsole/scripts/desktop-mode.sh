#!/bin/bash
# GoConsoleOS Desktop Mode
# KDE Plasma desktop with GoConsoleOS theming
# (Similar to SteamOS Desktop Mode)

# Set GoConsoleOS environment
export XDG_CURRENT_DESKTOP=KDE
export DESKTOP_SESSION=plasma

# Apply GoConsoleOS theme
if [ -f /usr/share/goconsole/themes/apply-theme.sh ]; then
    source /usr/share/goconsole/themes/apply-theme.sh
fi

# Start controller manager in background
/usr/share/goconsole/scripts/controller-manager.sh --watch &

# Start Plasma
if command -v startplasma-x11 &> /dev/null; then
    exec startplasma-x11
elif command -v startplasma-wayland &> /dev/null; then
    exec startplasma-wayland
elif command -v startkde &> /dev/null; then
    exec startkde
elif command -v startx &> /dev/null; then
    exec startx
else
    exec openbox-session
fi

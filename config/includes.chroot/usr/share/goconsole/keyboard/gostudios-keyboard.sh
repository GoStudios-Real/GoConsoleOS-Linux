#!/bin/bash
# GoConsoleOS On-Screen Keyboard
# Custom gamepad-accessible on-screen keyboard
# Toggle with: Super+K or Select button on controller

KEYBOARD_DIR="/usr/share/goconsole/keyboard"
CONFIG="$HOME/.config/goconsole/keyboard.conf"

# Ensure config exists
mkdir -p "$HOME/.config/goconsole"
if [ ! -f "$CONFIG" ]; then
    cat > "$CONFIG" << 'EOF'
# GoConsoleOS Keyboard Config
THEME=gostudios
FONT_SIZE=24
OPACITY=220
POSITION=bottom
TOGGLE_KEY=Super+k
CONTROLLER_TOGGLE=Select
WIDTH=100
HEIGHT=40
EOF
fi

# Read config
THEME=$(grep THEME= "$CONFIG" | cut -d= -f2)
FONT_SIZE=$(grep FONT_SIZE= "$CONFIG" | cut -d= -f2)
OPACITY=$(grep OPACITY= "$CONFIG" | cut -d= -f2)

# Check if keyboard is already running
if pgrep -f "gostudios-keyboard" > /dev/null 2>&1; then
    kill $(pgrep -f "gostudios-keyboard") 2>/dev/null
    exit 0
fi

# Launch onboard with GoConsoleOS theme if available
if command -v onboard &> /dev/null; then
    onboard --theme="$KEYBOARD_DIR/gostudios.theme" &
    exit 0
fi

# Fallback: matchbox-keyboard
if command -v matchbox-keyboard &> /dev/null; then
    matchbox-keyboard &
    exit 0
fi

# Fallback: xvkbd
if command -v xvkbd &> /dev/null; then
    xvkbd -geometry "100x4+0+1080" &
    exit 0
fi

echo "No on-screen keyboard found"
exit 1

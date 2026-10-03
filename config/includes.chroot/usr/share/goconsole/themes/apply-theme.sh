#!/bin/bash
# GoConsoleOS Theme Applier
# Applies GoStudios branding to KDE Plasma

THEME_DIR="/usr/share/goconsole/themes"
WALLPAPER="/usr/share/goconsole/wallpapers/goconsole-blue.png"
ACCENT="#0066FF"
BG_DARK="#0D0D14"
BG_MEDIUM="#141A2E"
BG_CARD="#1E2D42"

# Set wallpaper
if [ -f "$WALLPAPER" ]; then
    # KDE Plasma wallpaper
    if command -v plasma-apply-wallpaperimage &> /dev/null; then
        plasma-apply-wallpaperimage "$WALLPAPER" 2>/dev/null || true
    fi
    # Fallback: nitrogen
    if command -v nitrogen &> /dev/null; then
        nitrogen --set-zoom-fill "$WALLPAPER" 2>/dev/null || true
    fi
    # Fallback: feh
    if command -v feh &> /dev/null; then
        feh --bg-fill "$WALLPAPER" 2>/dev/null || true
    fi
fi

# KDE color scheme
COLORSCHEME="$HOME/.local/share/color-schemes/GoConsoleOS.colors"
mkdir -p "$HOME/.local/share/color-schemes"
cat > "$COLORSCHEME" << 'EOF'
[ColorEffects:Disabled]
Color=112,111,110

[ColorEffects:Inactive]
ChangeSelectionColor=true

[Colors:Button]
BackgroundAlternate=30,45,85
BackgroundNormal=30,45,66
ForegroundActive=0,102,255
ForegroundInactive=74,74,106
ForegroundLink=0,102,255
ForegroundNegative=255,68,68
ForegroundNormal=240,240,255
ForegroundPositive=0,204,102
ForegroundVisited=51,133,255

[Colors:Selection]
BackgroundNormal=0,102,255
ForegroundNormal=255,255,255

[Colors:View]
BackgroundAlternate=20,26,46
BackgroundNormal=13,13,20
ForegroundActive=0,102,255
ForegroundNormal=240,240,255

[Colors:Window]
BackgroundAlternate=20,26,46
BackgroundNormal=20,26,46
ForegroundNormal=240,240,255
EOF

# Apply color scheme
if command -v plasma-apply-colorscheme &> /dev/null; then
    plasma-apply-colorscheme GoConsoleOS 2>/dev/null || true
fi

echo "GoConsoleOS theme applied"

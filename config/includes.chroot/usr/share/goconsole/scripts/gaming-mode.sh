#!/bin/bash
# GoConsoleOS Gaming Mode
# Launches Steam Big Picture / Gamescope for console-like experience
# (Similar to SteamOS Gaming Mode)

export STEAM_RUNTIME=1
export MANGOHUD=1

# Performance overlay (like SteamOS)
if command -v mangohud &> /dev/null; then
    export MANGOHUD_CONFIG="fps,cpu_temp,gpu_temp,ram,vram,battery,frame_timing,position=top-left"
fi

# GameMode (auto performance tuning)
if command -v gamemoderun &> /dev/null; then
    export LD_PRELOAD="/usr/\$LIB/libgamemodeauto.so"
fi

# Try Gamescope first (like SteamOS)
if command -v gamescope &> /dev/null && [ "$USE_GAMESCOPE" != "0" ]; then
    echo "Starting GoConsoleOS Gaming Mode (Gamescope)..."
    gamescope -e -- steam -bigpicture &
    exit 0
fi

# Fallback: Steam Big Picture
if command -v steam &> /dev/null; then
    echo "Starting GoConsoleOS Gaming Mode (Big Picture)..."
    steam -bigpicture &
    exit 0
fi

# Fallback: Lutris (game library)
if command -v lutris &> /dev/null; then
    echo "Starting GoConsoleOS Gaming Mode (Lutris)..."
    lutris &
    exit 0
fi

echo "No game launcher found. Install steam or lutris."
exit 1

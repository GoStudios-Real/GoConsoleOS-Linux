#!/bin/bash
sleep 2
if command -v bluetoothctl &> /dev/null; then
    device=$(bluetoothctl devices Connected 2>/dev/null | grep -i "controller\|gamepad\|xbox\|dualshock\|switch")
    if [ -n "$device" ]; then
        name=$(echo "$device" | cut -d' ' -f3-)
        notify-send "GoConsoleOS" "Bluetooth controller connected: $name" 2>/dev/null || true
    fi
fi

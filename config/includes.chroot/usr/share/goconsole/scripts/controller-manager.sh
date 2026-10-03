#!/bin/bash
# GoConsoleOS Controller Manager
# Detects, configures, and monitors game controllers

CONFIG_DIR="$HOME/.config/goconsole"
LOG_FILE="$CONFIG_DIR/controller.log"
mkdir -p "$CONFIG_DIR"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"; }

detect_controllers() {
    log "Scanning for controllers..."
    local found=0
    
    # Check joystick devices
    for dev in /dev/input/js*; do
        if [ -e "$dev" ]; then
            idx=$(basename "$dev" | sed 's/js//')
            name=$(cat /proc/bus/input/devices 2>/dev/null | grep -A5 "Handlers=js$idx" | grep Name | cut -d'"' -f2)
            if [ -n "$name" ]; then
                log "Found: $name (js$idx)"
                found=$((found+1))
                
                # Detect type
                case "$name" in
                    *[Xx]box*) type="Xbox" ;;
                    *[Dd]ual[Ss]hock*|*[Pp][Ss]4*) type="PlayStation 4" ;;
                    *[Dd]ual[Ss]ense*|*[Pp][Ss]5*) type="PlayStation 5" ;;
                    *[Nn]intendo*|*Switch*) type="Nintendo" ;;
                    *[Nn]okia*) type="Nokia" ;;
                    *) type="Generic" ;;
                esac
                
                echo "CONTROLLER=$name"
                echo "TYPE=$type"
                echo "DEVICE=$dev"
            fi
        fi
    done
    
    # Check bluetooth
    if command -v bluetoothctl &> /dev/null; then
        bt_devices=$(bluetoothctl devices Paired 2>/dev/null | grep -i "controller\|gamepad\|xbox\|dualshock\|dualsense\|switch")
        if [ -n "$bt_devices" ]; then
            log "Bluetooth controllers found"
            while IFS= read -r line; do
                addr=$(echo "$line" | awk '{print $2}')
                name=$(echo "$line" | cut -d' ' -f3-)
                log "BT: $name ($addr)"
                echo "BT_CONTROLLER=$name"
            done <<< "$bt_devices"
        fi
    fi
    
    if [ $found -eq 0 ]; then
        log "No controllers found"
        echo "NO_CONTROLLERS=true"
    fi
    
    return $found
}

setup_xpad() {
    # Load Xbox controller driver
    modprobe xpad 2>/dev/null || true
    modprobe xone 2>/dev/null || true
    log "xpad module loaded"
}

setup_uinput() {
    # Ensure uinput is loaded for virtual controllers
    modprobe uinput 2>/dev/null || true
    if [ -e /dev/uinput ]; then
        chmod 666 /dev/uinput 2>/dev/null || true
        log "uinput ready"
    fi
}

apply_udev() {
    # Reload udev rules
    udevadm control --reload-rules 2>/dev/null || true
    udevadm trigger --subsystem-match=input 2>/dev/null || true
    log "udev rules reloaded"
}

# Main
setup_xpad
setup_uinput
apply_udev

if [ "$1" = "--detect" ]; then
    detect_controllers
elif [ "$1" = "--watch" ]; then
    log "Watching for controller connections..."
    # Use inotifywait or udev monitor
    if command -v udevadm &> /dev/null; then
        udevadm monitor --subsystem-match=input --udev | while read line; do
            if echo "$line" | grep -q "add"; then
                sleep 1
                log "Controller added event"
                detect_controllers
                notify-send "GoConsoleOS" "Controller connected!" 2>/dev/null || true
            fi
        done
    fi
else
    detect_controllers
fi

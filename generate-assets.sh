#!/bin/bash
# GoConsoleOS Wallpaper Generator
# Generates wallpapers using ImageMagick or Python PIL
set -e

WALLPAPER_DIR="$(cd "$(dirname "$0")" && pwd)/config/includes.chroot/usr/share/goconsole/wallpapers"
LOGO_DIR="$(cd "$(dirname "$0")" && pwd)/assets/logos"
mkdir -p "$WALLPAPER_DIR"

echo "Generating GoConsoleOS wallpapers..."

# Try ImageMagick first
if command -v convert &> /dev/null; then
    echo "Using ImageMagick..."
    
    # Blue wave wallpaper (main)
    convert -size 1920x1080 xc:'#0D0D14' \
        -fill '#141A2E' -draw "rectangle 0,0 1920,400" \
        -fill '#0066FF' -draw "rectangle 0,400 1920,420" \
        -fill '#0066FF33' -draw "polygon 0,500 960,350 1920,500 1920,600 0,600" \
        -fill '#0066FF22' -draw "polygon 0,650 480,550 960,650 1440,550 1920,650 1920,750 0,750" \
        -fill '#3385FF44' -draw "circle 960,540 960,480" \
        -fill '#0066FF' -font "Helvetica-Bold" -pointsize 72 -gravity North -annotate +0+150 "GoConsoleOS" \
        -fill '#7A80A0' -font "Helvetica" -pointsize 32 -gravity South -annotate +0+80 "GoStudios Corporation" \
        -fill '#4A4A6A' -font "Helvetica" -pointsize 24 -gravity South -annotate +0+40 "USB-Powered Gaming Console" \
        "$WALLPAPER_DIR/goconsole-blue.png"
    
    # Dark gaming wallpaper
    convert -size 1920x1080 gradient:'#0D0D14'-'#1E2D42' \
        -fill '#0066FF22' -draw "circle 960,540 960,340" \
        -fill '#0066FF11' -draw "circle 960,540 960,140" \
        -fill '#0066FF' -font "Helvetica-Bold" -pointsize 96 -gravity Center -annotate +0+0 "GoConsoleOS" \
        -fill '#00C9DB' -font "Helvetica" -pointsize 36 -gravity South -annotate +0+120 "Game Mode Ready" \
        "$WALLPAPER_DIR/goconsole-dark.png"
    
    # Light wallpaper
    convert -size 1920x1080 xc:'#141A2E' \
        -fill '#1E2D42' -draw "circle 400,300 400,0" \
        -fill '#0066FF44' -draw "circle 1500,800 1500,500" \
        -fill '#0066FF' -font "Helvetica-Bold" -pointsize 72 -gravity Center -annotate -200-100 "GoConsoleOS" \
        -fill '#7A80A0' -font "Helvetica" -pointsize 28 -gravity Center -annotate -200+40 "Gaming Mode | Desktop Mode" \
        "$WALLPAPER_DIR/goconsole-split.png"
        
    echo "Wallpapers generated (ImageMagick)"
    exit 0
fi

# Fallback: Python PIL
if command -v python3 &> /dev/null || command -v python &> /dev/null; then
    PY=$(command -v python3 || command -v python)
    echo "Using Python PIL..."
    $PY -c "
import struct, zlib, os, math

def create_png(width, height, filename, pixels):
    def chunk(ctype, data):
        c = ctype + data
        return struct.pack('>I', len(data)) + c + struct.pack('>I', zlib.crc32(c) & 0xffffffff)
    
    raw = b''
    for y in range(height):
        raw += b'\x00'
        for x in range(width):
            idx = (y * width + x) * 3
            raw += bytes(pixels[idx:idx+3])
    
    png = b'\x89PNG\r\n\x1a\n'
    png += chunk(b'IHDR', struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0))
    png += chunk(b'IDAT', zlib.compress(raw, 9))
    png += chunk(b'IEND', b'')
    
    with open(filename, 'wb') as f:
        f.write(png)
    print(f'Created {filename}')

W, H = 1920, 1080
out = os.environ.get('WALLPAPER_DIR', '/usr/share/goconsole/wallpapers')

# Blue wave wallpaper
pixels = []
for y in range(H):
    for x in range(W):
        r, g, b = 13, 13, 20
        # Top gradient
        if y < 400:
            t = y / 400.0
            r = int(13 + t * 7); g = int(13 + t * 13); b = int(20 + t * 26)
        # Blue accent line
        if 400 <= y < 420:
            r, g, b = 0, 102, 255
        # Wave
        wave = math.sin(x / 200.0 + 1.5) * 100 + 550
        if abs(y - wave) < 3:
            r, g, b = 0, 102, 255
        elif abs(y - wave) < 50:
            r, g, b = min(r + 10, 30), min(g + 15, 50), min(b + 30, 80)
        # Secondary wave
        wave2 = math.sin(x / 300.0 + 3.0) * 80 + 650
        if abs(y - wave2) < 3:
            r, g, b = 0, 102, 255
        # Center glow
        cx, cy = W//2, H//2
        d = math.sqrt((x-cx)**2 + (y-cy)**2)
        if d < 200:
            glow = (1 - d/200.0) * 40
            r = min(int(r + glow), 30); g = min(int(g + glow), 80); b = min(int(b + glow), 160)
        pixels.extend([r, g, b])

create_png(W, H, os.path.join(out, 'goconsole-blue.png'), pixels)
" WALLPAPER_DIR="$WALLPAPER_DIR"
    echo "Wallpapers generated (Python)"
    exit 0
fi

echo "WARNING: Neither ImageMagick nor Python available"
echo "Will use solid color fallback"
echo "#0D0D14" > "$WALLPAPER_DIR/fallback.txt"
exit 0

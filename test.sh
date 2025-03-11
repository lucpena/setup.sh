#!/bin/bash

# Directory containing fonts
FONT_DIR="./fonts"

# System-wide fonts directory
SYSTEM_FONT_DIR="/usr/local/share/fonts"

# Check if the fonts directory exists
if [ -d "$FONT_DIR" ]; then
    # Loop through each font file in the directory
    for font in "$FONT_DIR"/*; do
        # Get the base name of the font file
        font_name=$(basename "$font")
        
        # Check if the font already exists in the system-wide directory
        if [ -f "$SYSTEM_FONT_DIR/$font_name" ]; then
            echo "Font $font_name already exists, skipping..."
        else
            # Copy the font to the system-wide fonts directory
            sudo cp "$font" "$SYSTEM_FONT_DIR"
            echo "Font $font_name installed."
        fi
    done
    
    # Refresh the font cache
    sudo fc-cache -fv

    # Open the system-wide fonts directory
    xdg-open "$SYSTEM_FONT_DIR"
    
    echo "Fonts installed system-wide and cache refreshed."
else
    echo "Fonts directory not found."
fi
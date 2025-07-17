#!/bin/bash
# Script to create standalone binary using PyInstaller

set -e

echo "Creating standalone binary for pyfs-utils..."

# Install PyInstaller if not available
if ! command -v pyinstaller &> /dev/null; then
    echo "Installing PyInstaller..."
    pip install --break-system-packages PyInstaller
fi

# Install package if not already installed
echo "Installing package..."
pip install --break-system-packages -e .

# Create binary
echo "Creating binary with PyInstaller..."
pyinstaller --onefile --name pyfs-fibonacci $(which pyfs-fibonacci)

# Test binary
echo "Testing binary..."
./dist/pyfs-fibonacci 5

echo "Binary created successfully!"
echo "Location: ./dist/pyfs-fibonacci"
echo "Test with: ./dist/pyfs-fibonacci 10"
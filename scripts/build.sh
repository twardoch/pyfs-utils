#!/bin/bash
# Build script for pyfs-utils

set -e

echo "Building pyfs-utils..."

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf build/ dist/ *.egg-info/

# Install build dependencies
echo "Installing build dependencies..."
pip install --break-system-packages -U build setuptools setuptools_scm

# Build the package
echo "Building package..."
python3 -m build

echo "Build completed successfully!"
echo "Built packages:"
ls -la dist/
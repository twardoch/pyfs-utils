#!/bin/bash
# Test script for pyfs-utils

set -e

echo "Running tests for pyfs-utils..."

# Install test dependencies
echo "Installing test dependencies..."
pip install --break-system-packages -U pytest pytest-cov

# Install package in development mode
echo "Installing package in development mode..."
pip install --break-system-packages -e .

# Run tests
echo "Running tests..."
python3 -m pytest tests/ -v --cov=pyfs_utils --cov-report=term-missing --cov-report=html

# Run linting if flake8 is available
if command -v flake8 &> /dev/null; then
    echo "Running linting..."
    flake8 src/pyfs_utils/ tests/
else
    echo "Flake8 not available, skipping linting..."
fi

echo "Tests completed successfully!"
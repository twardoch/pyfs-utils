#!/bin/bash
# Script to validate that the binary/console script works correctly

set -e

echo "Validating pyfs-utils binary installation..."

# Install the package
echo "Installing package..."
pip install --break-system-packages -e .

# Check if the console script is available
echo "Checking console script availability..."
if command -v pyfs-fibonacci &> /dev/null; then
    echo "✓ Console script 'pyfs-fibonacci' is available"
else
    echo "✗ Console script 'pyfs-fibonacci' is NOT available"
    exit 1
fi

# Test the console script
echo "Testing console script functionality..."
output=$(pyfs-fibonacci 10)
expected="The 10-th Fibonacci number is 55"

if [[ "$output" == "$expected" ]]; then
    echo "✓ Console script works correctly: $output"
else
    echo "✗ Console script output is incorrect"
    echo "Expected: $expected"
    echo "Got: $output"
    exit 1
fi

# Test with version flag
echo "Testing version flag..."
version_output=$(pyfs-fibonacci --version)
if [[ "$version_output" == *"pyfs-utils"* ]]; then
    echo "✓ Version flag works: $version_output"
else
    echo "✗ Version flag failed: $version_output"
    exit 1
fi

# Test with help flag
echo "Testing help flag..."
help_output=$(pyfs-fibonacci --help)
if [[ "$help_output" == *"Fibonacci demonstration"* ]]; then
    echo "✓ Help flag works correctly"
else
    echo "✗ Help flag failed"
    exit 1
fi

echo "All binary validation tests passed!"
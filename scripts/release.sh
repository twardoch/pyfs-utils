#!/bin/bash
# Release script for pyfs-utils

set -e

# Function to display help
show_help() {
    cat << EOF
Usage: $0 [OPTIONS] [VERSION]

Release script for pyfs-utils

OPTIONS:
    -h, --help      Show this help message
    -t, --test      Run tests before release
    -p, --publish   Publish to PyPI (default: test PyPI)
    --pypi          Publish to production PyPI instead of test PyPI
    --dry-run       Show what would be done without actually doing it

VERSION:
    Semantic version number (e.g., 1.0.0)
    If not provided, will be determined from git tags

Examples:
    $0 1.0.0                    # Create and tag version 1.0.0
    $0 --test 1.0.0             # Run tests, then create version 1.0.0
    $0 --publish --pypi 1.0.0   # Release to production PyPI
    $0 --dry-run 1.0.0          # Show what would be done
EOF
}

# Parse command line arguments
DRY_RUN=false
RUN_TESTS=false
PUBLISH=false
USE_PYPI=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -t|--test)
            RUN_TESTS=true
            shift
            ;;
        -p|--publish)
            PUBLISH=true
            shift
            ;;
        --pypi)
            USE_PYPI=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            VERSION="$1"
            shift
            ;;
    esac
done

# Validate version format
if [[ -n "$VERSION" ]]; then
    if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "Error: Version must be in format X.Y.Z (e.g., 1.0.0)"
        exit 1
    fi
fi

echo "Starting release process for pyfs-utils..."

# Run tests if requested
if [[ "$RUN_TESTS" == true ]]; then
    echo "Running tests..."
    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would run: ./scripts/test.sh"
    else
        ./scripts/test.sh
    fi
fi

# Create git tag if version is provided
if [[ -n "$VERSION" ]]; then
    echo "Creating git tag v$VERSION..."
    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would run: git tag v$VERSION"
        echo "[DRY RUN] Would run: git push origin v$VERSION"
    else
        git tag "v$VERSION"
        git push origin "v$VERSION"
    fi
fi

# Build the package
echo "Building package..."
if [[ "$DRY_RUN" == true ]]; then
    echo "[DRY RUN] Would run: ./scripts/build.sh"
else
    ./scripts/build.sh
fi

# Publish if requested
if [[ "$PUBLISH" == true ]]; then
    echo "Installing twine for publishing..."
    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY RUN] Would install twine"
    else
        pip install --break-system-packages -U twine
    fi
    
    if [[ "$USE_PYPI" == true ]]; then
        echo "Publishing to PyPI..."
        if [[ "$DRY_RUN" == true ]]; then
            echo "[DRY RUN] Would run: twine upload dist/*"
        else
            twine upload dist/*
        fi
    else
        echo "Publishing to Test PyPI..."
        if [[ "$DRY_RUN" == true ]]; then
            echo "[DRY RUN] Would run: twine upload --repository testpypi dist/*"
        else
            twine upload --repository testpypi dist/*
        fi
    fi
fi

echo "Release process completed!"
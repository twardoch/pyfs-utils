#!/bin/bash
# Development setup script for pyfs-utils

set -e

echo "Setting up development environment for pyfs-utils..."

# Install development dependencies
echo "Installing development dependencies..."
pip install --break-system-packages -U \
    build \
    wheel \
    setuptools \
    setuptools_scm \
    pytest \
    pytest-cov \
    flake8 \
    black \
    isort \
    twine

# Install package in development mode
echo "Installing package in development mode..."
pip install --break-system-packages -e .

# Create pre-commit configuration
echo "Creating pre-commit configuration..."
cat > .pre-commit-config.yaml << EOF
repos:
  - repo: https://github.com/psf/black
    rev: 22.3.0
    hooks:
      - id: black
        args: [--line-length=88]
  - repo: https://github.com/pycqa/isort
    rev: 5.10.1
    hooks:
      - id: isort
        args: [--profile=black]
  - repo: https://github.com/pycqa/flake8
    rev: 4.0.1
    hooks:
      - id: flake8
        args: [--max-line-length=88, --extend-ignore=E203,W503]
  - repo: local
    hooks:
      - id: pytest
        name: pytest
        entry: python -m pytest tests/ -v
        language: python
        pass_filenames: false
        always_run: true
EOF

echo "Development environment setup completed!"
echo "You can now run:"
echo "  ./scripts/test.sh     - Run tests"
echo "  ./scripts/build.sh    - Build package"
echo "  ./scripts/release.sh  - Release package"
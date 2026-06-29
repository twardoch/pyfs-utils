#!/usr/bin/env bash
# install.sh: Install pyfs-utils in editable mode
# pyfs-utils: Python filesystem utilities

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== Installing pyfs-utils (editable) ==="
uv pip install -e .
echo "=== Install complete ==="

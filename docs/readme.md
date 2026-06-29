# pyfs-utils

[![CI](https://github.com/twardoch/pyfs-utils/actions/workflows/ci.yml/badge.svg)](https://github.com/twardoch/pyfs-utils/actions/workflows/ci.yml)
[![Release](https://github.com/twardoch/pyfs-utils/actions/workflows/release.yml/badge.svg)](https://github.com/twardoch/pyfs-utils/actions/workflows/release.yml)
[![PyPI version](https://badge.fury.io/py/pyfs-utils.svg)](https://badge.fury.io/py/pyfs-utils)
[![Python versions](https://img.shields.io/pypi/pyversions/pyfs-utils.svg)](https://pypi.org/project/pyfs-utils/)
[![License](https://img.shields.io/badge/license-CC0--1.0-blue.svg)](LICENSE.txt)

**pyfs-utils** extends [PyFilesystem2](https://pyfilesystem.org/) with additional utilities for working with filesystems. PyFilesystem2 provides a consistent API for local files, S3 buckets, FTP servers, ZIP files, and other filesystem types. This project builds on that foundation with practical tools and helpers.

Key features:
- Git-tag-based semantic versioning
- CI/CD pipeline with GitHub Actions
- Multiplatform support (Linux, Windows, macOS)
- Standalone binary distributions
- 100% test coverage with pytest
- Development scripts for building and releasing

## Current Status

`pyfs-utils` currently includes a template (`skeleton.py`) demonstrating how to create both importable Python modules and command-line scripts. The template uses a Fibonacci calculator as placeholder code, but shows the structure for future filesystem utilities.

## Target Audience

This library serves Python developers who:
- Work with multiple filesystem types (local, cloud, archives)
- Need portable file and directory manipulation code
- Want pre-built utilities or a framework for custom PyFilesystem2 tools
- Build CLI tools that interact with various filesystems

## Installation

### From PyPI
```bash
pip install pyfs-utils
```

### From Source
```bash
git clone https://github.com/twardoch/pyfs-utils.git
cd pyfs-utils
pip install .
```

For development:
```bash
pip install -e .
```

### Binary Downloads

Standalone executables available for:
- Linux (x86_64)
- Windows (x86_64)
- macOS (x86_64 and arm64)

Download from the [releases page](https://github.com/twardoch/pyfs-utils/releases). No Python installation required.

### Dependencies

Automatically installs `PyFilesystem2` and extensions:
`fs-s3fs`, `fs.dropboxfs`, `fs.webdavfs`, `fs.sshfs`, `fs.youtube`, `fs.archive`, `fs.googledrivefs`, `fs-gcsfs`, `gitfs2`, `pypifs`, `fs.proxy`, `httpfs`.

## Usage

### Command Line

The template includes an example `fibonacci` script. To enable it:

1. Uncomment these lines in `setup.cfg`:
    ```ini
    console_scripts =
         fibonacci = pyfs_utils.skeleton:run
    ```

2. Reinstall the package.

Run:
```bash
fibonacci 10
# Output: The 10-th Fibonacci number is 55
```

Future filesystem CLI tools will follow this pattern.

### Python Library

Import functions for use in your projects:
```python
from pyfs_utils.skeleton import fib

number = 10
result = fib(number)
print(f"The {number}-th Fibonacci number is {result}")
```

Future utilities will work similarly with PyFilesystem2 URLs or FS objects.

## Development

### Quick Setup
```bash
git clone https://github.com/twardoch/pyfs-utils.git
cd pyfs-utils
make setup
make test
make build
./scripts/create-binary.sh
```

### Commands
- `make help` - Show available commands
- `make test` - Run tests with coverage
- `make build` - Build package
- `make clean` - Remove build artifacts
- `make lint` - Run code linting
- `make format` - Format code
- `make release VERSION=x.y.z` - Create new release

### Release Process
1. Use semantic versioning with git tags (`v1.0.0`)
2. Push tag to trigger GitHub Actions release
3. CI builds for Linux, Windows, macOS
4. PyInstaller creates standalone binaries
5. PyPI publishing happens automatically

## Technical Details

### Code Structure
- `src/pyfs_utils/` - Main library code
  - `__init__.py` - Package initialization and versioning
  - `skeleton.py` - Template for new utilities
- `tests/` - pytest unit tests
- `docs/` - Sphinx documentation
- `setup.py` & `setup.cfg` - Packaging configuration
- `pyproject.toml` - Build system requirements

### Packaging
- Uses `setuptools` for packaging
- Dependencies listed in `setup.cfg`
- CLI entry points defined in `[options.entry_points]`

### Template Pattern (`skeleton.py`)
- API functions for programmatic use
- CLI interface with `argparse`
- `run()` entry point for setuptools

### Contributing
- Follow PEP 8 coding standards
- Use `flake8` for linting (configured in `setup.cfg`)
- Format code with Black
- Write tests with pytest
- Document code with Google-style docstrings
- Use `setuptools_scm` for versioning (no manual `VERSION.txt` updates)

Workflow:
1. Fork repository
2. Create feature branch
3. Add code, tests, documentation
4. Run local tests and linters
5. Commit with descriptive messages
6. Push branch
7. Open PR against `main`

### Other Files
- Issue tracking via GitHub Issues
- License: CC0-1.0 (see `LICENSE.txt`)
- Authors and contributors: `AUTHORS.md`
- Changelog: `CHANGELOG.md`
- AI agent instructions: `AGENTS.md` (if needed)

## Note

This project uses PyScaffold 4.0.2. See https://pyscaffold.org/ for details.
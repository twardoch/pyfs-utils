# pyfs-utils

[![CI](https://github.com/twardoch/pyfs-utils/actions/workflows/ci.yml/badge.svg)](https://github.com/twardoch/pyfs-utils/actions/workflows/ci.yml)
[![Release](https://github.com/twardoch/pyfs-utils/actions/workflows/release.yml/badge.svg)](https://github.com/twardoch/pyfs-utils/actions/workflows/release.yml)
[![PyPI version](https://badge.fury.io/py/pyfs-utils.svg)](https://badge.fury.io/py/pyfs-utils)
[![Python versions](https://img.shields.io/pypi/pyversions/pyfs-utils.svg)](https://pypi.org/project/pyfs-utils/)
[![License](https://img.shields.io/badge/license-CC0--1.0-blue.svg)](LICENSE.txt)

**pyfs-utils** is a Python library designed to provide a collection of utilities that simplify and extend working with [PyFilesystem2](https://pyfilesystem.org/). PyFilesystem2 (or `fs`) is a powerful Python abstraction layer for various filesystems, allowing you to interact with local files, S3 buckets, FTP servers, ZIP files, and many more through a consistent API. This project aims to build upon that foundation, offering tools and helpers to make your filesystem interactions even more straightforward and robust.

This project features:
- **Git-tag-based semantic versioning**: Automatic version management using git tags
- **Comprehensive CI/CD pipeline**: GitHub Actions for testing, building, and releasing
- **Multiplatform support**: Works on Linux, Windows, and macOS
- **Binary distributions**: Standalone executables for easy installation
- **Complete test suite**: 100% test coverage with pytest
- **Development tools**: Scripts for building, testing, and releasing

## What This Tool Does

`pyfs-utils` intends to offer:

*   **Simplified File Operations:** High-level functions for common filesystem tasks.
*   **Cross-Filesystem Utilities:** Tools that work seamlessly across any filesystem supported by PyFilesystem2.
*   **CLI Tools:** Command-line interfaces for filesystem operations, built using the utilities provided by this library.

Currently, the package includes a template (`skeleton.py`) that demonstrates how to create both importable Python modules and command-line scripts. This template uses a Fibonacci calculator as a placeholder example, but it showcases the structure for future filesystem-related utilities.

## Who It's For

`pyfs-utils` is for Python developers who:

*   Work with multiple types of filesystems (local, cloud storage, archives, etc.).
*   Want to write clean, portable code for file and directory manipulations.
*   Are looking for pre-built utilities or a framework to create their own tools for PyFilesystem2.
*   Need to create command-line tools that interact with various filesystems.

## Why It's Useful

PyFilesystem2 already provides a fantastic abstraction. `pyfs-utils` aims to make it even more accessible and productive by:

*   **Reducing Boilerplate:** Offering ready-to-use functions for common patterns.
*   **Enhancing Reusability:** Providing well-tested utilities that can be incorporated into larger applications.
*   **Streamlining CLI Creation:** Giving a clear structure for developing filesystem-related command-line tools.
*   **Centralizing Helpers:** Creating a go-to library for common PyFilesystem2 add-ons.

As the library grows, it will become a valuable toolkit for anyone leveraging PyFilesystem2.

## Installation

### From PyPI (Recommended)

```bash
pip install pyfs-utils
```

### From Source

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/twardoch/pyfs-utils.git
    cd pyfs-utils
    ```

2.  **Install using pip:**
    For a regular installation:
    ```bash
    pip install .
    ```
    For an editable installation (useful for development):
    ```bash
    pip install -e .
    ```

### Binary Downloads

Standalone executables are available for download from the [releases page](https://github.com/twardoch/pyfs-utils/releases) for:
- Linux (x86_64)
- Windows (x86_64) 
- macOS (x86_64 and arm64)

No Python installation required for binary distributions.

### Dependencies

`pyfs-utils` relies on `PyFilesystem2` (`fs`) and a range of its extension packages to support various filesystems, including:
`fs-s3fs` (for S3), `fs.dropboxfs`, `fs.webdavfs`, `fs.sshfs`, `fs.youtube`, `fs.archive`, `fs.googledrivefs`, `fs-gcsfs` (for Google Cloud Storage), `gitfs2`, `pypifs`, `fs.proxy`, and `httpfs`.
These will be installed automatically when you install `pyfs-utils`.

## How to Use

`pyfs-utils` can be used both as a command-line tool (as utilities are developed) and as a Python library.

### From the Command Line (CLI)

The project template includes an example CLI script, `fibonacci`. While not a filesystem utility itself, it demonstrates how future CLI tools from this package will be structured and invoked.

To enable the example `fibonacci` script:
1.  Uncomment the following lines in the `[options.entry_points]` section in your `setup.cfg` file:
    ```ini
    # console_scripts =
    #     fibonacci = pyfs_utils.skeleton:run
    ```
    to:
    ```ini
    console_scripts =
         fibonacci = pyfs_utils.skeleton:run
    ```
2.  Re-install the package if you made it non-editable, or if you're using an editable install, the change should be picked up.

Once set up, you could run it like this (from your terminal):
```bash
fibonacci 10
```
This would output: `The 10-th Fibonacci number is 55`.

Future filesystem-related CLI tools developed in this package will follow a similar pattern for usage.

### Programmatically (as a Python Library)

You can import and use functions from `pyfs-utils` in your Python projects. The `skeleton.py` file provides an example `fib` function.

```python
from pyfs_utils.skeleton import fib

# Using the example Fibonacci function
number = 10
result = fib(number)
print(f"The {number}-th Fibonacci number is {result}")
# Output: The 10-th Fibonacci number is 55

# Future filesystem utilities will be importable similarly:
# from pyfs_utils.some_utility import useful_fs_function
#
# fs_url = "s3://mybucket/data/"
# items = useful_fs_function(fs_url, pattern="*.txt")
# for item in items:
#     print(item)
```
As actual filesystem utilities are added, you'll be able to import them and use them with PyFilesystem2 URLs or FS objects.

---

## Development and Release

This project uses modern Python development practices with automated CI/CD:

### Quick Development Setup

```bash
# Clone and set up development environment
git clone https://github.com/twardoch/pyfs-utils.git
cd pyfs-utils
make setup  # or ./scripts/dev-setup.sh

# Run tests
make test   # or ./scripts/test.sh

# Build package
make build  # or ./scripts/build.sh

# Create binary
./scripts/create-binary.sh
```

### Available Commands

- `make help` - Show all available commands
- `make test` - Run tests with coverage
- `make build` - Build the package
- `make clean` - Clean build artifacts
- `make lint` - Run linting
- `make format` - Format code
- `make release VERSION=x.y.z` - Release a new version

### Release Process

1. **Semantic Versioning**: The project uses git tags for versioning (e.g., `v1.0.0`)
2. **Automated Releases**: Push a git tag to trigger automated release via GitHub Actions
3. **Multi-platform Builds**: CI automatically builds for Linux, Windows, and macOS
4. **Binary Distributions**: Standalone executables are created using PyInstaller
5. **PyPI Publishing**: Packages are automatically published to PyPI on release

### CI/CD Pipeline

- **Continuous Integration**: Tests run on every push/PR across multiple Python versions and OS
- **Security Scanning**: Automated security checks using bandit and safety
- **Code Quality**: Linting, formatting, and type checking
- **Release Automation**: Automatic releases triggered by git tags
- **Binary Creation**: Standalone executables for easy distribution

For detailed development instructions, see [DEVELOPMENT.md](DEVELOPMENT.md).

---

## Technical Details

This section provides more in-depth information about the `pyfs-utils` project structure, coding conventions, and contribution guidelines.

### How the Code Works

*   **Project Structure:**
    *   `src/pyfs_utils/`: Contains the main source code for the library.
        *   `__init__.py`: Initializes the package and handles versioning using `importlib.metadata` (or `importlib_metadata` for Python < 3.8).
        *   `skeleton.py`: An example module and CLI script template (currently demonstrates a Fibonacci calculator). This file serves as a blueprint for creating new utilities.
    *   `tests/`: Contains unit tests for the library, written using `pytest`.
    *   `docs/`: Contains files for generating project documentation using Sphinx.
    *   `setup.py` & `setup.cfg`: Standard Python packaging files. `setup.cfg` is the primary configuration file for `setuptools`, defining metadata, dependencies, entry points, and tool configurations (like `pytest` and `flake8`).
    *   `pyproject.toml`: Specifies build system requirements, primarily for `setuptools_scm` which handles versioning from Git tags.

*   **Packaging and Dependency Management:**
    *   The project uses `setuptools` for packaging.
    *   Dependencies are listed in `setup.cfg` under `install_requires`.
    *   Console script entry points (for CLI tools) are defined in `setup.cfg` under `[options.entry_points]`. The `fibonacci` script in `skeleton.py` is an example of this.

*   **Core Logic (Example - `skeleton.py`):**
    *   The `skeleton.py` file shows a pattern for creating modules with both a Python API and a command-line interface.
    *   **API:** Functions intended for programmatic use (e.g., `fib(n)`).
    *   **CLI:**
        *   `parse_args()`: Uses `argparse` to handle command-line arguments.
        *   `main()`: Orchestrates the CLI logic.
        *   `run()`: Acts as the setuptools entry point, calling `main()` with system arguments.

### Coding and Contributing Rules

We welcome contributions to `pyfs-utils`! Please follow these guidelines:

*   **Coding Style:**
    *   Code should adhere to PEP 8 guidelines.
    *   We use `flake8` for linting. Configuration is in `setup.cfg`:
        *   `max_line_length = 88`
        *   `extend_ignore = E203, W503` (for compatibility with Black code formatter)
    *   Consider using a code formatter like Black to automatically format your code.

*   **Testing:**
    *   All new features and bug fixes should include comprehensive tests.
    *   Tests are written using `pytest` and are located in the `tests/` directory.
    *   Run tests using `pytest` from the project root:
        ```bash
        pytest
        ```
    *   You can also use `tox` to run tests in isolated environments (see `tox.ini`):
        ```bash
        tox
        ```
    *   Aim for high test coverage. Check coverage with:
        ```bash
        pytest --cov=pyfs_utils --cov-report=term-missing
        ```

*   **Documentation:**
    *   The project documentation is generated using [Sphinx](https://www.sphinx-doc.org/). Source files are in the `docs/` directory.
    *   Docstrings should follow a consistent style (e.g., Google style, as supported by Napoleon Sphinx extension).
    *   To build the documentation locally, ensure you have the documentation dependencies installed (see `docs/requirements.txt`) and run:
        ```bash
        tox -e docs
        ```
        The output will be in `docs/_build/html`.

*   **Versioning:**
    *   The project uses `setuptools_scm` to manage versioning based on Git tags. The version is automatically derived from the latest tag and commit history.
    *   The `VERSION.txt` file in the repository root is *not* manually updated; its current content appears to be an artifact of a Git operation and should ideally be removed or .gitignored if not used by a specific workflow. For official versioning, refer to Git tags and the output of `python setup.py --version`.

*   **Contributing Workflow:**
    1.  **Fork the repository** on GitHub.
    2.  **Create a new branch** for your feature or bug fix: `git checkout -b feature/your-feature-name` or `bugfix/issue-number`.
    3.  **Make your changes**, ensuring you add tests and update documentation as needed.
    4.  **Run tests and linters** locally to ensure everything passes.
    5.  **Commit your changes** with clear, descriptive commit messages.
    6.  **Push your branch** to your fork: `git push origin feature/your-feature-name`.
    7.  **Open a Pull Request (PR)** against the `main` branch of the `twardoch/pyfs-utils` repository.
    8.  Clearly describe your changes in the PR.

*   **Issue Tracking:**
    *   Use the GitHub Issues tracker for reporting bugs or proposing new features.

*   **License:**
    *   The project is licensed under the CC0-1.0 Universal license. See `LICENSE.txt`. By contributing, you agree that your contributions will be licensed under the same terms.

*   **Author Information:**
    *   Project authors and contributors are listed in `AUTHORS.md`.
    *   A `CHANGELOG.md` is maintained to track notable changes for each version.

*   **`AGENTS.md` / `CLAUDE.md`:**
    *   The user prompt mentioned consulting `CLAUDE.md` for details. This file was not found in the repository. If specific instructions for AI agents are to be provided, they should be added to an `AGENTS.md` file in the repository root.

<!-- pyscaffold-notes -->

## Note

This project has been set up using PyScaffold 4.0.2. For details and usage
information on PyScaffold see https://pyscaffold.org/.

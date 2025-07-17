# Development Guide for pyfs-utils

This guide explains how to set up your development environment and contribute to `pyfs-utils`.

## Quick Start

1. **Clone the repository**:
   ```bash
   git clone https://github.com/twardoch/pyfs-utils.git
   cd pyfs-utils
   ```

2. **Set up development environment**:
   ```bash
   make setup
   # or
   ./scripts/dev-setup.sh
   ```

3. **Run tests**:
   ```bash
   make test
   # or
   ./scripts/test.sh
   ```

4. **Build the package**:
   ```bash
   make build
   # or
   ./scripts/build.sh
   ```

## Development Workflow

### Available Commands

The project includes several convenient commands via Makefile:

- `make help` - Show all available commands
- `make setup` - Set up development environment
- `make test` - Run tests with coverage
- `make build` - Build the package
- `make clean` - Clean build artifacts
- `make lint` - Run linting
- `make format` - Format code
- `make check` - Run all checks (lint + test)
- `make release VERSION=x.y.z` - Release a new version
- `make version` - Show current version

### Testing

Tests are located in the `tests/` directory and use pytest:

```bash
# Run all tests
make test

# Run specific test file
python -m pytest tests/test_skeleton.py -v

# Run with coverage
python -m pytest tests/ -v --cov=pyfs_utils --cov-report=html
```

### Code Quality

The project uses several tools to maintain code quality:

- **flake8**: Linting
- **black**: Code formatting
- **isort**: Import sorting
- **pytest**: Testing
- **bandit**: Security scanning
- **safety**: Dependency vulnerability scanning

Run all quality checks:
```bash
make check
```

### Versioning

The project uses semantic versioning with git tags:

1. **Git-based versioning**: Version is automatically determined from git tags using `setuptools_scm`
2. **Semantic versioning**: Use format `MAJOR.MINOR.PATCH` (e.g., `1.0.0`)
3. **Development versions**: Between tags, versions include development info

### Creating a Release

1. **Run tests and build**:
   ```bash
   make check
   make build
   ```

2. **Create and push tag**:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

3. **Or use the release script**:
   ```bash
   make release VERSION=1.0.0
   ```

### CI/CD Pipeline

The project uses GitHub Actions for CI/CD:

- **CI Pipeline** (`.github/workflows/ci.yml`):
  - Runs on push/PR to main/develop
  - Tests on multiple Python versions and OS
  - Runs linting and formatting checks
  - Builds the package

- **Release Pipeline** (`.github/workflows/release.yml`):
  - Triggered by git tags
  - Runs full test suite
  - Builds packages for multiple platforms
  - Creates GitHub release
  - Publishes to PyPI

- **Security Pipeline** (`.github/workflows/security.yml`):
  - Runs security scans
  - Checks for vulnerabilities
  - Runs weekly

### Development Scripts

The `scripts/` directory contains useful development scripts:

- `dev-setup.sh` - Set up development environment
- `test.sh` - Run tests
- `build.sh` - Build package
- `release.sh` - Release package with options

### Package Structure

```
pyfs-utils/
├── src/pyfs_utils/        # Source code
│   ├── __init__.py        # Package initialization
│   └── skeleton.py        # Example module
├── tests/                 # Test files
│   ├── conftest.py        # Test configuration
│   └── test_skeleton.py   # Test cases
├── scripts/               # Development scripts
├── docs/                  # Documentation
├── .github/               # GitHub Actions workflows
├── setup.cfg              # Package configuration
├── pyproject.toml         # Build system configuration
├── Makefile              # Development commands
└── README.md             # Project documentation
```

### Contributing

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes**
4. **Run tests and checks**:
   ```bash
   make check
   ```
5. **Commit your changes**:
   ```bash
   git commit -m "Add your feature"
   ```
6. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```
7. **Create a Pull Request**

### Code Style

- Follow PEP 8 guidelines
- Use `black` for code formatting
- Use `isort` for import sorting
- Maximum line length: 88 characters
- Write comprehensive tests for new features
- Add docstrings for all public functions

### Dependencies

The project has minimal dependencies:
- Core: `fs` (PyFilesystem2) and related packages
- Development: `pytest`, `black`, `flake8`, `isort`
- Build: `build`, `setuptools`, `setuptools_scm`

### Environment Variables

No special environment variables are required for development.

### Troubleshooting

**Build issues**:
- Ensure you have the latest setuptools_scm: `pip install -U setuptools_scm`
- Clean build artifacts: `make clean`

**Test issues**:
- Install in development mode: `pip install -e .`
- Check Python version compatibility

**Version issues**:
- Ensure git repository has tags: `git tag --list`
- Check setuptools_scm configuration in `pyproject.toml`

For more help, check the issue tracker or create a new issue.
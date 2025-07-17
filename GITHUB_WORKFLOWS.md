# GitHub Actions Workflows

Since the GitHub App doesn't have permission to create workflow files, please create these files manually in your repository:

## 1. Create `.github/workflows/ci.yml`

```yaml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        python-version: ['3.8', '3.9', '3.10', '3.11', '3.12']
    
    steps:
    - uses: actions/checkout@v4
      with:
        fetch-depth: 0  # Needed for setuptools_scm
    
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v5
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -e .[testing]
        pip install pytest-cov
    
    - name: Run tests
      run: |
        pytest tests/ -v --cov=pyfs_utils --cov-report=xml
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v4
      with:
        file: ./coverage.xml
        fail_ci_if_error: false
        verbose: true
        token: ${{ secrets.CODECOV_TOKEN }}

  lint:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: '3.12'
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install flake8 black isort
        pip install -e .
    
    - name: Lint with flake8
      run: |
        flake8 src/pyfs_utils/ tests/
    
    - name: Check formatting with black
      run: |
        black --check src/pyfs_utils/ tests/
    
    - name: Check import sorting with isort
      run: |
        isort --check-only src/pyfs_utils/ tests/

  build:
    runs-on: ubuntu-latest
    needs: [test, lint]
    steps:
    - uses: actions/checkout@v4
      with:
        fetch-depth: 0
    
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: '3.12'
    
    - name: Install build dependencies
      run: |
        python -m pip install --upgrade pip
        pip install build
    
    - name: Build package
      run: |
        python -m build
    
    - name: Upload artifacts
      uses: actions/upload-artifact@v4
      with:
        name: dist
        path: dist/
```

## 2. Create `.github/workflows/release.yml`

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        python-version: ['3.8', '3.9', '3.10', '3.11', '3.12']
    
    steps:
    - uses: actions/checkout@v4
      with:
        fetch-depth: 0
    
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v5
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -e .[testing]
        pip install pytest-cov
    
    - name: Run tests
      run: |
        pytest tests/ -v --cov=pyfs_utils --cov-report=xml

  build:
    runs-on: ${{ matrix.os }}
    needs: test
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        python-version: ['3.8', '3.9', '3.10', '3.11', '3.12']
    
    steps:
    - uses: actions/checkout@v4
      with:
        fetch-depth: 0
    
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v5
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install build dependencies
      run: |
        python -m pip install --upgrade pip
        pip install build PyInstaller
    
    - name: Build package
      run: |
        python -m build
    
    - name: Install package for binary creation
      run: |
        pip install dist/*.whl
    
    - name: Create binary with PyInstaller (Unix)
      if: matrix.os != 'windows-latest'
      run: |
        pyinstaller --onefile --name pyfs-fibonacci-${{ matrix.os }}-py${{ matrix.python-version }} $(which pyfs-fibonacci)
    
    - name: Create binary with PyInstaller (Windows)
      if: matrix.os == 'windows-latest'
      run: |
        pyinstaller --onefile --name pyfs-fibonacci-${{ matrix.os }}-py${{ matrix.python-version }}.exe $(python -c "import sys; print(sys.executable.replace('python.exe', 'Scripts/pyfs-fibonacci.exe'))")
    
    - name: Test binary (Unix)
      if: matrix.os != 'windows-latest'
      run: |
        ./dist/pyfs-fibonacci-${{ matrix.os }}-py${{ matrix.python-version }} 5
    
    - name: Test binary (Windows)
      if: matrix.os == 'windows-latest'
      run: |
        ./dist/pyfs-fibonacci-${{ matrix.os }}-py${{ matrix.python-version }}.exe 5
    
    - name: Upload package artifacts
      uses: actions/upload-artifact@v4
      with:
        name: dist-${{ matrix.os }}-py${{ matrix.python-version }}
        path: dist/
    
    - name: Upload binary artifacts
      uses: actions/upload-artifact@v4
      with:
        name: binary-${{ matrix.os }}-py${{ matrix.python-version }}
        path: |
          dist/pyfs-fibonacci-*

  release:
    runs-on: ubuntu-latest
    needs: build
    if: startsWith(github.ref, 'refs/tags/v')
    
    steps:
    - uses: actions/checkout@v4
      with:
        fetch-depth: 0
    
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: '3.12'
    
    - name: Install build dependencies
      run: |
        python -m pip install --upgrade pip
        pip install build twine
    
    - name: Build package
      run: |
        python -m build
    
    - name: Download all artifacts
      uses: actions/download-artifact@v4
      with:
        path: artifacts/
    
    - name: Create GitHub Release
      uses: ncipollo/release-action@v1
      with:
        artifacts: "dist/*,artifacts/binary-*/*"
        token: ${{ secrets.GITHUB_TOKEN }}
        draft: false
        prerelease: false
        generateReleaseNotes: true
    
    - name: Publish to PyPI
      env:
        TWINE_USERNAME: __token__
        TWINE_PASSWORD: ${{ secrets.PYPI_TOKEN }}
      run: |
        twine upload dist/*
    
    - name: Publish to Test PyPI
      env:
        TWINE_USERNAME: __token__
        TWINE_PASSWORD: ${{ secrets.TEST_PYPI_TOKEN }}
      run: |
        twine upload --repository testpypi dist/* || true
```

## 3. Create `.github/workflows/security.yml`

```yaml
name: Security

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 2 * * 1'  # Weekly on Monday at 2 AM

jobs:
  security:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v5
      with:
        python-version: '3.12'
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -e .[testing]
        pip install bandit safety
    
    - name: Run Bandit (security linter)
      run: |
        bandit -r src/pyfs_utils/ -f json -o bandit-report.json || true
        bandit -r src/pyfs_utils/
    
    - name: Run Safety (dependency vulnerability scanner)
      run: |
        safety check --json --output safety-report.json || true
        safety check
    
    - name: Upload security reports
      uses: actions/upload-artifact@v4
      if: always()
      with:
        name: security-reports
        path: |
          bandit-report.json
          safety-report.json
```

## 4. Create `.github/workflows/dependabot.yml`

```yaml
name: Dependabot Auto-Merge

on:
  pull_request:
    branches: [ main ]

jobs:
  dependabot:
    runs-on: ubuntu-latest
    if: github.actor == 'dependabot[bot]'
    steps:
    - name: Dependabot metadata
      id: metadata
      uses: dependabot/fetch-metadata@v2.2.0
      with:
        github-token: "${{ secrets.GITHUB_TOKEN }}"
    
    - name: Auto-merge Dependabot PRs
      if: steps.metadata.outputs.update-type == 'version-update:semver-patch' || steps.metadata.outputs.update-type == 'version-update:semver-minor'
      run: gh pr merge --auto --merge "$PR_URL"
      env:
        PR_URL: ${{ github.event.pull_request.html_url }}
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

## 5. Create `.github/dependabot.yml`

```yaml
version: 2
updates:
  # Enable version updates for pip
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
    reviewers:
      - "twardoch"
    assignees:
      - "twardoch"
    open-pull-requests-limit: 10
    allow:
      - dependency-type: "all"
    commit-message:
      prefix: "deps"
      include: "scope"
  
  # Enable version updates for GitHub Actions
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    reviewers:
      - "twardoch"
    assignees:
      - "twardoch"
    open-pull-requests-limit: 5
    commit-message:
      prefix: "ci"
      include: "scope"
```

## Setup Instructions

1. **Create the directories**:
   ```bash
   mkdir -p .github/workflows
   ```

2. **Create each workflow file** with the content above

3. **Set up repository secrets** (in GitHub Settings > Secrets and variables > Actions):
   - `PYPI_TOKEN`: Your PyPI API token (optional, for publishing)
   - `TEST_PYPI_TOKEN`: Your Test PyPI API token (optional)
   - `CODECOV_TOKEN`: Your Codecov token (optional, for coverage reports)

4. **Test the workflows**:
   - Push to main/develop branch to trigger CI
   - Create and push a git tag to trigger release workflow

## Notes

- The workflows are designed to work with the current project structure
- Binary creation uses PyInstaller for standalone executables
- Security scanning runs weekly and on pushes
- Dependabot will automatically update dependencies
- All workflows include proper error handling and artifact uploads
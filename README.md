# pyfs-utils

[![CI](https://github.com/twardoch/pyfs-utils/actions/workflows/ci.yml/badge.svg)](https://github.com/twardoch/pyfs-utils/actions/workflows/ci.yml)
[![PyPI version](https://badge.fury.io/py/pyfs-utils.svg)](https://badge.fury.io/py/pyfs-utils)
[![Python versions](https://img.shields.io/pypi/pyversions/pyfs-utils.svg)](https://pypi.org/project/pyfs-utils/)
[![License](https://img.shields.io/badge/license-CC0--1.0-blue.svg)](LICENSE.txt)

**pyfs-utils** is a utility library built on [PyFilesystem2](https://pyfilesystem.org/) for working with files across different filesystem backends — local disk, S3, Dropbox, WebDAV, SSH, Google Drive, archives, and more — through a single unified API.

> **Current status:** Early development. `skeleton.py` is a structural placeholder; real filesystem utilities are forthcoming.

## Install

```bash
pip install pyfs-utils          # core (local filesystem only)
pip install pyfs-utils[s3]      # + Amazon S3
pip install pyfs-utils[ssh]     # + SSH / SFTP
pip install pyfs-utils[all]     # all backends
```

## Supported backends

| Extra | Backend |
|-------|---------|
| *(core)* | Local disk |
| `s3` | Amazon S3 |
| `dropbox` | Dropbox |
| `webdav` | WebDAV |
| `ssh` | SSH / SFTP |
| `archive` | ZIP / TAR archives |
| `googledrive` | Google Drive |
| `gcs` | Google Cloud Storage |

## Usage

```python
import fs

# The same API works for every backend
with fs.open_fs("osfs://~/Documents") as local:
    for path in local.walk.files(filter=["*.txt"]):
        print(path)

# Switch to S3 by changing only the URL
# with fs.open_fs("s3://mybucket/data/") as cloud:
#     ...
```

## CLI demo

```bash
pyfs-fibonacci 10
# The 10-th Fibonacci number is 55
```

## Development

```bash
git clone https://github.com/twardoch/pyfs-utils && cd pyfs-utils
pip install hatch
hatch test        # run tests
hatch run lint    # ruff check
hatch run fmt     # ruff format
hatch build       # build wheel + sdist
```

## Structure

- `src/pyfs_utils/__init__.py` — package version via hatch-vcs + git tags
- `src/pyfs_utils/skeleton.py` — CLI + library template (Fibonacci demo)
- `tests/` — pytest suite
- `pyproject.toml` — build, lint, and test configuration
- `docs/` — Jekyll site (served at <https://twardoch.github.io/pyfs-utils/>)

## License

[CC0-1.0](LICENSE.txt) Universal — public domain.

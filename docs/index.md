---
layout: home
title: pyfs-utils
---

# pyfs-utils

**pyfs-utils** is a utility library built on [PyFilesystem2](https://pyfilesystem.org/) for working with files across different filesystem backends through a single unified Python API.

## Supported backends

| Extra | Backend | Install |
|-------|---------|---------|
| *(core)* | Local disk | `pip install pyfs-utils` |
| `s3` | Amazon S3 | `pip install pyfs-utils[s3]` |
| `dropbox` | Dropbox | `pip install pyfs-utils[dropbox]` |
| `webdav` | WebDAV | `pip install pyfs-utils[webdav]` |
| `ssh` | SSH / SFTP | `pip install pyfs-utils[ssh]` |
| `archive` | ZIP / TAR archives | `pip install pyfs-utils[archive]` |
| `googledrive` | Google Drive | `pip install pyfs-utils[googledrive]` |
| `gcs` | Google Cloud Storage | `pip install pyfs-utils[gcs]` |
| `all` | All of the above | `pip install pyfs-utils[all]` |

## Quick start

```bash
pip install pyfs-utils
```

```python
import fs

# Open any supported filesystem the same way
with fs.open_fs("osfs://~/Documents") as my_fs:
    for path in my_fs.walk.files(filter=["*.txt"]):
        print(path)
```

## CLI demo

```bash
pyfs-fibonacci 10
# The 10-th Fibonacci number is 55
```

## Development status

The package is in early development. The `skeleton` module contains a
Fibonacci example that demonstrates the intended CLI and library patterns;
real filesystem utility functions are forthcoming.

## Pages

* [Changelog](changelog)
* [Authors](authors)
* [License](license)

## License

[CC0-1.0](https://creativecommons.org/publicdomain/zero/1.0/) — public domain.
# this_file: src/pyfs_utils/__init__.py
"""pyfs-utils: Utility library for working with files across PyFilesystem2 backends.

Provides helpers for local disk, S3, Dropbox, WebDAV, SSH, Google Drive,
Git repositories, archives, and any other PyFilesystem2-compatible backend
through a single unified API.
"""

from importlib.metadata import PackageNotFoundError, version

try:
    __version__: str = version("pyfs-utils")
except PackageNotFoundError:  # pragma: no cover
    __version__ = "unknown"

__all__ = ["__version__"]

# this_file: src/pyfs_utils/skeleton.py
"""Fibonacci CLI demo — placeholder showing the pyfs-utils entry-point pattern.

This module exists as a structural template while the real filesystem utilities
are being developed.  It can be removed once substantive modules are added.

Usage::

    pyfs-fibonacci 10       # prints the 10th Fibonacci number
    python -m pyfs_utils.skeleton 10
"""

import argparse
import logging
import sys
from collections.abc import Sequence

from pyfs_utils import __version__

__author__ = "Adam Twardoch"
__copyright__ = "Adam Twardoch"
__license__ = "CC0-1.0"

_logger = logging.getLogger(__name__)


# ---------------------------------------------------------------------------
# Python API
# ---------------------------------------------------------------------------


def fib(n: int) -> int:
    """Return the *n*-th Fibonacci number (1-indexed, F(1)=1, F(2)=1).

    Args:
        n: A positive integer position in the Fibonacci sequence.

    Returns:
        The *n*-th Fibonacci number.

    Raises:
        AssertionError: If *n* is not a positive integer.

    Examples:
        >>> fib(1)
        1
        >>> fib(10)
        55
    """
    assert n > 0, f"n must be a positive integer, got {n}"
    a, b = 1, 1
    for _ in range(n - 1):
        a, b = b, a + b
    return a


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------


def parse_args(args: Sequence[str]) -> argparse.Namespace:
    """Parse command-line parameters.

    Args:
        args: Command-line arguments as a list of strings,
            e.g. ``["--verbose", "42"]``.

    Returns:
        Parsed :class:`argparse.Namespace` with attributes ``n`` and
        ``loglevel``.
    """
    parser = argparse.ArgumentParser(description="Fibonacci demonstration for pyfs-utils")
    parser.add_argument(
        "--version",
        action="version",
        version=f"pyfs-utils {__version__}",
    )
    parser.add_argument(
        dest="n",
        help="compute the n-th Fibonacci number",
        type=int,
        metavar="INT",
    )
    parser.add_argument(
        "-v",
        "--verbose",
        dest="loglevel",
        help="set log level to INFO",
        action="store_const",
        const=logging.INFO,
    )
    parser.add_argument(
        "-vv",
        "--very-verbose",
        dest="loglevel",
        help="set log level to DEBUG",
        action="store_const",
        const=logging.DEBUG,
    )
    return parser.parse_args(args)


def setup_logging(loglevel: int | None) -> None:
    """Configure root logger.

    Args:
        loglevel: Minimum log level to emit.  ``None`` disables logging.
    """
    if loglevel is None:
        return
    logformat = "[%(asctime)s] %(levelname)s:%(name)s:%(message)s"
    logging.basicConfig(
        level=loglevel,
        stream=sys.stdout,
        format=logformat,
        datefmt="%Y-%m-%d %H:%M:%S",
    )


def main(args: Sequence[str]) -> None:
    """Entry point for the ``pyfs-fibonacci`` CLI command.

    Args:
        args: Command-line arguments as a list of strings,
            e.g. ``["--verbose", "42"]``.
    """
    parsed = parse_args(args)
    setup_logging(parsed.loglevel)
    _logger.debug("Starting calculation…")
    print(f"The {parsed.n}-th Fibonacci number is {fib(parsed.n)}")
    _logger.info("Done.")


def run() -> None:
    """Invoke :func:`main` with arguments from :data:`sys.argv`.

    Registered as the ``pyfs-fibonacci`` console-script entry point.
    """
    main(sys.argv[1:])


if __name__ == "__main__":
    run()

# Makefile for pyfs-utils

.PHONY: help setup test build clean lint format check release dev-setup install

PYTHON := python3
PIP := pip3

help:  ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

setup: dev-setup  ## Alias for dev-setup

dev-setup:  ## Set up development environment
	./scripts/dev-setup.sh

install:  ## Install package in development mode
	$(PIP) install --break-system-packages -e .

test:  ## Run tests
	./scripts/test.sh

build:  ## Build package
	./scripts/build.sh

clean:  ## Clean build artifacts
	rm -rf build/ dist/ *.egg-info/ htmlcov/ .coverage .pytest_cache/
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

lint:  ## Run linting
	$(PYTHON) -m flake8 src/pyfs_utils/ tests/

format:  ## Format code
	$(PYTHON) -m black src/pyfs_utils/ tests/
	$(PYTHON) -m isort src/pyfs_utils/ tests/

check: lint test  ## Run all checks (lint + test)

release:  ## Release package (use VERSION=x.y.z)
ifdef VERSION
	./scripts/release.sh --test $(VERSION)
else
	@echo "Please specify VERSION, e.g., make release VERSION=1.0.0"
	@exit 1
endif

release-publish:  ## Release and publish to PyPI (use VERSION=x.y.z)
ifdef VERSION
	./scripts/release.sh --test --publish --pypi $(VERSION)
else
	@echo "Please specify VERSION, e.g., make release-publish VERSION=1.0.0"
	@exit 1
endif

version:  ## Show current version
	$(PYTHON) setup.py --version

git-tag:  ## Create git tag (use VERSION=x.y.z)
ifdef VERSION
	git tag v$(VERSION)
	git push origin v$(VERSION)
else
	@echo "Please specify VERSION, e.g., make git-tag VERSION=1.0.0"
	@exit 1
endif

docs:  ## Build documentation
	cd docs && make html

docs-serve:  ## Serve documentation locally
	cd docs/_build/html && $(PYTHON) -m http.server 8000

binary:  ## Create standalone binary
	./scripts/create-binary.sh

validate:  ## Validate binary installation
	./scripts/validate-binary.sh

all: clean setup test build  ## Run full build pipeline
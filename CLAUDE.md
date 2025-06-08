# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Copier template for modern Python machine learning projects. It generates ML project structures with modern Python tooling including uv, ruff, mypy, pytest, and mkdocs-material.

## Key Architecture

- **Template Engine**: Uses Copier with Jinja2 templating
- **Project Structure**: Follows data science best practices with separate directories for data, models, notebooks, configs, and reports
- **Package Management**: Built around uv with optional CUDA variants for PyTorch
- **Code Quality**: Enforced via ruff (formatting/linting), mypy (type checking), and pre-commit hooks
- **Documentation**: Uses mkdocs-material with mkdocstrings for API docs
- **Release Management**: Automated with git-cliff and conventional commits

## Common Development Commands

### Template Development
```bash
# Test template generation and project functionality
make test

# Generate a test project for development
make gen

# Clean test artifacts
make clean
```

### Project Setup (for generated projects)
```bash
# Install dependencies with uv
uv sync --group dev --group docs --extra cu124

# Setup development environment
make setup

# Run commands in virtual environment
make run <command>

# Format and lint code
uv run ruff format .
uv run ruff check . --fix
uv run mypy src/

# Run tests
uv run pytest

# Build documentation
uv run mkdocs build
```

### Release Process
```bash
# Check next version
uv run git-cliff --bumped-version

# Create release (runs git-cliff, commits, tags, pushes)
sh scripts/release.sh
```

## Template Configuration

The `copier.yml` file defines template prompts and variables. Key features:
- Supports both GitHub and GitLab CI
- Configurable directory names for data, models, notebooks, etc.
- Optional package creation with proper Python packaging setup
- CUDA variant selection for PyTorch projects

## Pre-commit Configuration

Uses comprehensive pre-commit hooks including:
- Ruff for formatting and linting
- Conventional commit enforcement
- Markdown linting
- TOML/YAML validation
- Commit signing

Always run `uvx pre-commit run -a` before committing template changes.

## Testing Strategy

Template testing happens in `tests/`:
- `test_project.sh`: End-to-end template generation and project setup
- Generated projects are tested in `tests/tmp/`
- Tests verify file structure, basic commands, and tool integration

## Key Files

- `copier.yml`: Template configuration and prompts
- `project/`: Template source directory
- `project/pyproject.toml.jinja`: Main project configuration template
- `project/scripts/make`: Management script for generated projects
- `extensions.py`: Custom Jinja2 extensions for templating


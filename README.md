# Copier Modern Machine Learning Template

[![Copier](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/copier-org/copier/master/img/badge/badge-grayscale-inverted-border-orange.json)](https://github.com/copier-org/copier)
[![CI](https://github.com/appleparan/copier-modern-ml/actions/workflows/ci.yml/badge.svg)](https://github.com/appleparan/copier-modern-ml/actions?query=workflow%3Aci)
[![docs](https://readthedocs.org/projects/copier-modern-ml/badge/?version=latest)](https://copier-modern-ml.readthedocs.io/en/latest/?badge=latest)

[Copier](https://copier.readthedocs.io/en/stable/)
template with modern Python workflows

Inspired by [copier-uv](https://github.com/pawamoy/copier-uv),
[cookiecutter-data-science](https://github.com/drivendataorg/cookiecutter-data-science),
and [BestieTemplates.jl](https://github.com/JuliaBesties/BestieTemplate.jl).

## Packaging Guide

* Check out [pyOpenSci Python Package Guide](https://www.pyopensci.org/python-package-guide/index.html)

## Features

* Uses [uv](https://github.com/astral-sh/uv)
for project and package management, which includes the following tools:
  * [ruff](https://github.com/charliermarsh/ruff) for code formatting and quality analysis
  * [mypy](https://github.com/python/mypy) for type checking
* Testing is done with [pytest](https://github.com/pytest-dev/pytest) and its plugins
* Documentation is built with [mkdocs-material](https://github.com/squidfunk/mkdocs-material)
  and [mkdocstrings plugin](https://github.com/mkdocstrings/mkdocstrings)
* Supports GitHub workflows, including:
  * Automatic release with semantic versioning
  * Auto-generated `CHANGELOG.md` and release notes using [git-cliff](https://github.com/orhun/git-cliff)
    * Requires [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0-beta.2/).

## How to use it

### Install dependencies

* Python 3.12+
* copier >= 9.7.1
* uv >= 0.7.0

### Install copier (global)

```bash
uv tool install copier
```

### Start new project

```bash
uvx --with copier_templates_extensions copier copy --trust gh:appleparan/copier-modern-ml ~/src/PATH/TO/YOUR/PROJECT
```

### Install Python and packages

```bash
cd ~/src/PATH/TO/YOUR/PROJECT
uv python install 3.13
uv python pin 3.13
uv sync --group dev --group docs --extra cu126
```

### Initialize git

Finally, initialize git, then install `pre-commit` hooks.
(it takes some time at the first installation)

```bash
uv tool install pre-commit
git init
git add .
uvx pre-commit run -a # Try to fix possible pre-commit issues (failures are expected)
git add .
git commit -m "First commit"
uvx pre-commit install # Future commits can't be directly to main unless you use -n
```

### The resulting directory structure

The directory structure of your new project will look something like this
(depending on the settings that you choose):

```plaintext
├── LICENSE            <- Open-source license if one is chosen
├── README.md          <- The top-level README for developers using this project.
├── mkdocs.yml         <- mkdocs-material configuration file.
├── pyproject.toml     <- Project configuration file with package metadata for
│                         {{ project_slug }} and configuration for tools like ruff
├── uv.lock            <- The lock file for reproducing the production environment, e.g.
│                         generated with `uv sync`
├── data
│   ├── external       <- Data from third party sources.
│   ├── interim        <- Intermediate data that has been transformed.
│   ├── processed      <- The final, canonical data sets for modeling.
│   └── raw            <- The original, immutable data dump.
├── docs               <- A default mkdocs project; see www.mkdocs.org for details
├── models             <- Trained and serialized models, model predictions, or model summaries
├── notebooks          <- Jupyter notebooks. Naming convention is a number (for ordering),
│                         the creator's initials, and a short `-` delimited description, e.g.
│                         `1.0-jqp-initial-data-exploration`.
├── references         <- Data dictionaries, manuals, and all other explanatory materials.
├── reports            <- Generated analysis as HTML, PDF, LaTeX, etc.
│   └── figures        <- Generated graphics and figures to be used in reporting
├── tests              <- Unit test files.
└── src/{{ project_slug }}   <- Source code for use in this project.
    │
    ├── __init__.py             <- Makes {{ project_slug }} a Python module
    │
    └── cli.py                  <- Default CLI program
```

## Development

### Generate package from local template
```shell
uvx --with copier_templates_extensions copier copy --vcs-ref HEAD --trust LOCAL_TEMPLATE_PATH PACKAGE_NAME
```

### Check next version
```shell
uv run git-cliff --bumped-version
```

### Release
Execute scripts
```
sh scripts/release.sh
```
What `release.sh` do:

1. Set next version to `BUMPED_VERSION`: This ensures that the `git-cliff --bumped-version` command produces consistent results.

```shell
BUMPED_VERSION=$(uv run git-cliff --bumped-version)
```

2. Generate `CHANGELOG.md` and `RELEASE.md`: The script creates or updates the changelog and release notes using the bumped version:

```shell
uv run git-cliff --strip header --tag $BUMPED_VERSION -o CHANGELOG.md
uv run git-cliff --latest --strip header --tag $BUMPED_VERSION --unreleased -o RELEASE.md
```

3. Commit updated `CHANGELOG.md` and `RELEASE.md` then add tags and push: It commits the updated files, creates a tag for the new version, and pushes the changes to the repository:

```shell
git add CHANGELOG.md RELEASE.md
git commit -am "docs: Add CHANGELOG.md and RELEASE.md to release $BUMPED_VERSION"
git tag -a $BUMPED_VERSION -m "Release $BUMPED_VERSION"
git push origin tag $BUMPED_VERSION
```

For dry run:
```shell
uv run git-cliff --latest --strip header --tag $(uv run git-cliff --bumped-version) --unreleased
```

### PyTorch Index URL (PyTorch 2.9.1)

| Compute Platform | Linux | Windows | macOS |
|------------------|-------|---------|-------|
| **CPU Only** | ☐ `https://download.pytorch.org/whl/cpu` | ☐ default | ☐ default |
| **CUDA 13.0** | ☐ `https://download.pytorch.org/whl/cu130` | ☐ `https://download.pytorch.org/whl/cu130` | ❌ Not supported |
| **CUDA 12.8** | ☐ default | ☐ `https://download.pytorch.org/whl/cu128` | ❌ Not supported |
| **CUDA 12.6** | ☐ `https://download.pytorch.org/whl/cu126` | ☐ `https://download.pytorch.org/whl/cu126` | ❌ Not supported |
| **ROCm 6.3** | ☐ `https://download.pytorch.org/whl/rocm6.3` | ❌ Not supported | ❌ Not supported |


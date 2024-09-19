# Copier Modern Machine Learning Template

[![Copier](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/copier-org/copier/master/img/badge/badge-grayscale-inverted-border-orange.json)](https://github.com/copier-org/copier)
[![CI](https://github.com/appleparan/copier-modern-ml/actions/workflows/ci.yml/badge.svg)](https://github.com/appleparan/copier-modern-ml/actions?query=workflow%3Aci)
[![docs](https://readthedocs.org/projects/copier-modern-ml/badge/?version=latest)](https://copier-modern-ml.readthedocs.io/en/latest/?badge=latest)

Personal [Copier](https://copier.readthedocs.io/en/stable/)
template with modern Python workflows

Inspired by [copier-uv](https://github.com/pawamoy/copier-uv),
[cookiecutter-data-science](https://github.com/drivendataorg/cookiecutter-data-science),
and [BestieTemplates.jl](https://github.com/abelsiqueira/BestieTemplate.jl).

## Packaging Guide

* Check out [pyOpenSci Python Package Guide](https://www.pyopensci.org/python-package-guide/index.html)

## Features

* Uses ~[rye](https://github.com/astral-sh/rye)~ [uv](https://github.com/astral-sh/uv)
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

* Python 3.11+
* copier >= 9.3.1
* uv >= 0.4.12

### Install copier (global)

```bash
uv tool install copier
```

### Start new project

```bash
uvx --with copier_templates_extensions copier copy --trust gh:appleparan/copier-modern-ml ~/path/to/your/project
```

### Install Python and packages

```bash
cd ~/path/to/your/project
uv python install 3.12
uv sync --dev --all-extras
```

### Intialize git

Finally, initialize git, then install `pre-commit` hooks.
(it takes some time at the first installation)

```bash
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
│
├── docs               <- A default mkdocs project; see www.mkdocs.org for details
│
├── models             <- Trained and serialized models, model predictions, or model summaries
│
├── notebooks          <- Jupyter notebooks. Naming convention is a number (for ordering),
│                         the creator's initials, and a short `-` delimited description, e.g.
│                         `1.0-jqp-initial-data-exploration`.
│
├── references         <- Data dictionaries, manuals, and all other explanatory materials.
│
├── reports            <- Generated analysis as HTML, PDF, LaTeX, etc.
│   └── figures        <- Generated graphics and figures to be used in reporting
│
│
├── src/tests          <- Unit test files.
│
└── src/{{ project_slug }}   <- Source code for use in this project.
    │
    ├── __init__.py             <- Makes {{ project_slug }} a Python module
    │
    └── cli.py                  <- Default CLI program
```

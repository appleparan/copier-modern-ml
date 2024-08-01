# Copier Modern Machine Learning Template

[![Copier](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/copier-org/copier/master/img/badge/badge-grayscale-inverted-border-orange.json)](https://github.com/copier-org/copier)
[![CI](https://github.com/appleparan/copier-modern-ml/actions/workflows/ci.yml/badge.svg)](https://github.com/appleparan/copier-modern-ml/actions?query=workflow%3Aci)
[![docs](https://readthedocs.org/projects/copier-modern-ml/badge/?version=latest)](https://copier-modern-ml.readthedocs.io/en/latest/?badge=latest)

Personal [Copier](https://copier.readthedocs.io/en/stable/) template with modern Python workflows

Inspired by [copier-uv](https://github.com/pawamoy/copier-uv) and [cookiecutter-data-science](https://github.com/drivendataorg/cookiecutter-data-science).

## Packaging Guide

Trying to follow [pyOpenSci Python Package Guide](https://www.pyopensci.org/python-package-guide/index.html)

## Features

- [rye](https://github.com/astral-sh/rye) for project and package management. Included following tools.
    - [uv](https://github.com/astral-sh/uv) setup, with pre-defined `pyproject.toml`
    - Pre-configured tools for code formatting, quality analysis and testing: [ruff](https://github.com/charliermarsh/ruff),
  [mypy](https://github.com/python/mypy),
- Tests run with [pytest](https://github.com/pytest-dev/pytest) and plugins, with [coverage](https://github.com/nedbat/coveragepy) support
- Documentation built with [MkDocs](https://github.com/mkdocs/mkdocs)
  ([Material theme](https://github.com/squidfunk/mkdocs-material)
  and "autodoc" [mkdocstrings plugin](https://github.com/mkdocstrings/mkdocstrings))
- Support for GitHub workflows
- Auto-generated `CHANGELOG.md` from Git (conventional) commits


# How to use it
## Install dependencies
* Python 3.11+
* copier >= 9.3.1

## Install copier
```bash
python -m pip instal copier copier_templates_extension
```

## To start a new project, run:
```bash
python -m copier copy --trust gh:appleparan/copier-modern-ml ~/path/to/your/subproject
```

### The resulting directory structure

The directory structure of your new project will look something like this (depending on the settings that you choose):

```
├── LICENSE            <- Open-source license if one is chosen
├── README.md          <- The top-level README for developers using this project.
├── mkdocs.yml         <- mkdocs-material configuration file.
├── pyproject.toml     <- Project configuration file with package metadata for
│                         {{ project_slug }} and configuration for tools like ruff
├── requirements.lock       <- The requirements lock file for reproducing the production environment, e.g.
│                              generated with `rye sync`
├── requirements-dev.lock   <- The requirements lock file for reproducing the development environment, e.g.
│                              generated with `rye sync`
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

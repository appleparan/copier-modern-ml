# Copier Modern Machine Learning Template (WIP)

[![Copier](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/copier-org/copier/master/img/badge/badge-grayscale-inverted-border-orange.json)](https://github.com/copier-org/copier)

Personal [copier](https://copier.readthedocs.io/en/stable/) template with modern Python workflows

Inspired by [copier-uv](https://github.com/pawamoy/copier-uv) and [cookiecutter-data-science](https://github.com/drivendataorg/cookiecutter-data-science).

## Packaging Guide

Trying to follow [pyOpenSci Python Package Guide](https://www.pyopensci.org/python-package-guide/index.html)

## Tools
* Use [rye](https://github.com/astral-sh/rye) with [ruff](https://docs.astral.sh/ruff/), [uv](https://docs.astral.sh/ruff/) for project management.
* Use [pytest](https://github.com/pytest-dev/pytest) for testing
* Use [mkdocs](https://www.mkdocs.org/) and [mkdocs-material](https://squidfunk.github.io/mkdocs-material/) for documentation.

# How to use it
## Install dependencies
* Python 3.11+
* copier >= 9.3.1

## Install copier
```bash
rye add copier
```

## To start a new project, run:
```bash
copier copy gh:appleparan/copier-modern-ml ~/path/to/your/subproject
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

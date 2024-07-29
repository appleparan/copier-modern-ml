# Cookiecutter Modern ML

Personal cookiecutter template with modern Python workflows

## Packaging Guide

Trying to follow [pyOpenSci Python Package Guide](https://www.pyopensci.org/python-package-guide/index.html)

## Tools
* Use [rye](https://github.com/astral-sh/rye) with [ruff](https://docs.astral.sh/ruff/), [uv](https://docs.astral.sh/ruff/) for project management.
* Use [pytest](https://github.com/pytest-dev/pytest) for testing
* Use [mkdocs](https://www.mkdocs.org/) and [mkdocs-material](https://squidfunk.github.io/mkdocs-material/) for documentation.

# How to use it
## Install dependencies
* Python 3.11+
* Cookiecutter >= 2.6.0

## Install cookiecutter
```bash
rye add cookiecutter
```

## To start a new project, run:
```bash
cookiecutter https://github.com/appleparan/cookiecutter-modern-ml.git
```

### The resulting directory structure

The directory structure of your new project will look something like this (depending on the settings that you choose):

```
├── LICENSE            <- Open-source license if one is chosen
├── README.md          <- The top-level README for developers using this project.
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
├── requirements.lock       <- The requirements lock file for reproducing the production environment, e.g.
│                              generated with `rye sync`
├── requirements-dev.lock   <- The requirements lock file for reproducing the development environment, e.g.
│                              generated with `rye sync`
├── pyproject.toml     <- Project configuration file with package metadata for
│                         {{ cookiecutter.project_slug }} and configuration for tools like black
│
├── src/tests          <- Unit test files.
│
└── src/{{ cookiecutter.project_slug }}   <- Source code for use in this project.
    │
    ├── __init__.py             <- Makes {{ cookiecutter.project_slug }} a Python module
    │
    └── cli.py                  <- Default CLI program
```

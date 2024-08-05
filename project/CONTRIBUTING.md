# Contributing

Contributions are welcome, and they are greatly appreciated!
Every little bit helps, and credit will always be given.

## Environment setup

You only need two tools, [rye](https://github.com/astral-sh/rye)
and [Copier](https://github.com/copier-org/copier).

Clone the repository, then enter it and install rye

```bash
git clone https://github.com/appleparan/copier-modern-ml.git
cd copier-modern-ml
curl -sSf https://rye.astral.sh/get | bash
rye pin 3.12
rye sync
```

## Running tests

To run the tests, use:

```bash
rye run test
```

## Serving docs

To serve the docs locally, use:

```bash
rye run mkdocs build
```

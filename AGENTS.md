# AGENTS.md

Copier template that generates modern Python ML projects (uv, ruff, ty,
pytest, mkdocs-material, git-cliff). `copier.yml` defines the prompts;
`project/` is the template source; `extensions.py` adds the Jinja filters
`slugify`, `git_user_name`, `git_user_email` and the `current_year` global.

## Gotchas

- **Tests render from `HEAD`, not the working tree.** `tests/helpers.sh`
  runs `copier copy -r HEAD`, so commit template changes before running
  `bash tests/test_project.sh` or `make gen`. The generated project lands in
  `tests/tmp/` and is deleted on the next run.
- **`bash tests/test_project.sh` is the real test entry point.** It generates
  the project, then runs `uv sync --extra cpu`, `ruff format --check`,
  `ruff check`, `ty check`, `mkdocs build --strict` and `pytest` inside it.
  The root `Makefile` still references `rye` and test scripts that no longer
  exist, so `make test`, `make setup` and `make format` do not work.
- **Two copies of every workflow and hook config.** `.github/workflows/*` and
  `.pre-commit-config.yaml` at the root are mirrored under `project/` for
  generated projects. Change both, or they drift.
- **Only `*.jinja` files are templated** (`_templates_suffix`). Anything else
  under `project/` is copied byte-for-byte, so Jinja syntax in a plain `.yml`
  or `.py` file is a bug, not a feature. Conditional files and directories
  are expressed in the file name, e.g. `{% if create_examples %}nlp.py{% endif %}.jinja`.
- **`create_examples: true` implies PyTorch.** The `use_torch` prompt is only
  asked when examples are off; the example modules import torch,
  transformers and datasets unconditionally.
- **Dependency cooldown.** Generated projects set
  `exclude-newer = "P7D"`, and `uv lock` in this repo honors the same
  cooldown. Pin only versions published at least 7 days ago or the lock
  fails. Check PyPI for yanked releases before bumping a pin.
- **Bumping torch means checking four indexes.** The template resolves torch
  and torchvision from `download.pytorch.org/whl/{cpu,cu126,cu130,cu132}`
  via explicit `[[tool.uv.index]]` entries plus PyPI (which ships the CUDA 13
  build). Confirm matching `cp313` wheels exist on every index before
  changing the pinned versions.
- **`astral-sh/setup-uv` publishes no floating major tags since v8.** Pin the
  full tag (`@v10.0.1`) and keep `version:` at a uv release the action has a
  known checksum for (see `src/download/checksum/known-checksums.ts` at that
  tag). The GitLab CI image tag
  `ghcr.io/astral-sh/uv:<uv>-python<py>-<base>` follows uv's Debian base
  (`trixie-slim` for uv 0.12.x); an unpublished combination fails at pull.
- **Type checker is `ty`, not mypy**, in both this repo and generated
  projects. `ruff` config in `project/pyproject.toml.jinja` uses an explicit
  `select` list, so ruff's expanded default rule set (0.16+) does not apply.

## Workflow

- Run `uvx pre-commit run -a` before committing. Hooks enforce conventional
  commit messages and sign commits.
- Release with `sh scripts/release.sh`: `git-cliff` picks the next version,
  `uv version` writes it, and the script commits, tags and pushes.
  `CHANGELOG.md` is `_skip_if_exists`, so `copier update` never overwrites a
  generated project's changelog.

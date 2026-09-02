# AGENTS.md

Copier template that generates modern Python ML projects (uv, ruff, ty,
pytest, ProperDocs, git-cliff). `copier.yml` defines the prompts;
`project/` is the template source; `extensions.py` adds the Jinja filters
`slugify`, `git_user_name`, `git_user_email` and the `current_year` global.

## Gotchas

- **Tests render the working tree, dirty changes included.** `tests/helpers.sh`
  runs `copier copy -r HEAD` on the local checkout; copier folds uncommitted
  changes in (it prints `DirtyLocalWarning`), so `make test` and `make gen`
  see your edits without a commit. Untracked files are included too. The
  generated project lands in `tests/tmp/` and is deleted on the next run.
- **`make test` is the full quality gate.** It generates the project into
  `tests/tmp/`, then runs `uv sync --extra cpu`, `ruff format --check`,
  `ruff check`, `ty check`, `properdocs build --strict` and `pytest` inside it
  (about 3 minutes; downloads CPU torch on first run). It also generates two
  `create_examples=no` variants into `tests/tmp-variants/` (one `ci=gitlab`,
  one `package=no create_directories=no`) and runs `ruff`, `ty` and `pytest`
  on each. `tests/test_project.ps1` only runs the default-answers generation,
  not the variants. `make lint` runs the pre-commit hooks that CI expects to
  be clean.
- **Two copies of every workflow and hook config.** `.github/workflows/*` and
  `.pre-commit-config.yaml` at the root are mirrored under `project/` for
  generated projects. Change both, or they drift — `tests/test_mirrored_files.py`
  (run by `make lint` and CI) fails when the pairs stop matching byte-for-byte.
  `docs/index.md` (root and `project/`) is a `pymdownx.snippets` include of
  `README.md` at both levels, so the same dedupe rule applies there too.
- **Only `*.jinja` files are templated** (`_templates_suffix`). Anything else
  under `project/` is copied byte-for-byte, so Jinja syntax in a plain `.yml`
  or `.py` file is a bug, not a feature. Conditional files and directories
  are expressed in the file name, e.g. `{% if create_examples %}nlp.py{% endif %}.jinja`.
- **`create_examples: true` implies PyTorch.** The `use_torch` prompt is only
  asked when examples are off; the example modules import torch and
  transformers unconditionally. The NLP example is inference-only (frozen
  `BAAI/bge-small-en-v1.5` semantic search); vision and tabular are the
  Lightning training examples.
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
  full tag (`@v10.0.1`). `version: latest-known` installs the newest uv whose
  checksum that tag ships, so bumping the action tag is what upgrades uv in
  GitHub CI. GitLab CI pins `UV_VERSION` explicitly because it is an image
  tag: `ghcr.io/astral-sh/uv:<uv>-python<py>-<base>` must exist, and the base
  follows uv's Debian release (`trixie-slim` for uv 0.12.x).
- **Type checker is `ty`, not mypy**, in both this repo and generated
  projects. `ruff` config in `project/pyproject.toml.jinja` uses an explicit
  `select` list, so ruff's expanded default rule set (0.16+) does not apply.
- **Docs build with ProperDocs, not MkDocs.** `properdocs` is a drop-in
  MkDocs fork; the config lives in `properdocs.yml`
  (`project/properdocs.yml.jinja`) and existing MkDocs plugins/themes
  (MaterialX, mkdocstrings, gen-files, literate-nav, section-index)
  work unchanged. Read the Docs has no `properdocs:` key, so
  `.readthedocs.yml` builds via `build.jobs.build.html`.
- **`allow_insecure_host` is a string prompt** (comma-separated hosts,
  default empty). Projects generated before this change have a bool in
  `.copier-answers.yml`; `pyproject.toml.jinja` tolerates that.
- **Build backend is `uv_build`** (pure-Python only). `make test` runs
  `uv build` and inspects the wheel; the module dir must equal
  `project_slug`.
- **`author_fullname`/`author_email` default to the local git identity.**
  `copier.yml` defaults them via the `git_user_name`/`git_user_email`
  Jinja filters (from `extensions.py`), so `--defaults` picks up
  `git config user.name`/`user.email` when the prompts aren't answered
  explicitly.

## Workflow

- Run `uvx pre-commit run -a` before committing. Hooks enforce conventional
  commit messages and sign commits.
- Release with `sh scripts/release.sh`: `git-cliff` picks the next version,
  `uv version` writes it, and the script commits, tags and pushes.
  `CHANGELOG.md` is `_skip_if_exists`, so `copier update` never overwrites a
  generated project's changelog.

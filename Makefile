.PHONY: $(MAKECMDGOALS)

PYTHON_VERSION ?= 3.14

changelog:
	@uv run git-cliff --strip header -o CHANGELOG.md

clean:
	@rm -rf tests/tmp
	@rm -rf tests/tmp-variants

cleantests:
	@rm -rf tests/tmp/.git
	@rm -rf tests/tmp/empty
	@rm -rf tests/tmp/CHANGELOG.md
	@rm -rf tests/tmp-variants

docs:
	@uvx --with-requirements docs/requirements.txt mkdocs build --strict

# Root-level Python only; template sources under project/ are checked by the
# generated project's own ruff config in `make test`.
format:
	@uvx ruff format extensions.py scripts

gen generate:
	@bash -c 'source tests/helpers.sh && generate ${PWD} tests/tmp'

lint:
	@uvx pre-commit run -a

release:
	@sh scripts/release.sh

setup:
	@uv python pin $(PYTHON_VERSION)
	@uv sync --group dev

# Renders the working tree, uncommitted changes included (see AGENTS.md).
test: cleantests
	@PYTHON_VERSION=$(PYTHON_VERSION) bash tests/test_project.sh

version:
	@uv run git-cliff --bumped-version

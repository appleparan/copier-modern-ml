.PHONY: $(MAKECMDGOALS)

PYTHON_VERSION ?= 3.14

changelog:
	@uv run git-cliff --strip header -o CHANGELOG.md

clean:
	@rm -rf tests/tmp

cleantests:
	@rm -rf tests/tmp/.git
	@rm -rf tests/tmp/empty
	@rm -rf tests/tmp/CHANGELOG.md

docs:
	@bun install && bun run build

docs-serve:
	@bun install && bun run dev

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

# Renders the template from the committed HEAD (see tests/helpers.sh),
# so commit template changes before running this.
test: cleantests
	@PYTHON_VERSION=$(PYTHON_VERSION) bash tests/test_project.sh

version:
	@uv run git-cliff --bumped-version

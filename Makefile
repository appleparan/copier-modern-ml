.PHONY: $(MAKECMDGOALS)

changelog:
	@.venv/bin/git-changelog -Tio CHANGELOG.md -Bauto -c angular -n pep440

clean:
	@rm -rf tests/tmp

cleantests:
	@rm -rf tests/tmp/.git
	@rm -rf tests/tmp/empty
	@rm -rf tests/tmp/CHANGELOG.md

docs:
	@rye run mkdocs build

format:
	@rye fmt

gen generate:
	@bash -c 'source tests/helpers.sh && generate ${PWD} tests/tmp'

reset-history: gen
	@bash tests/reset_history.sh

setup:
	@rye pin 3.12
	@rye sync

test: cleantests
	@bash tests/test_filenames.sh
	@bash tests/test_project.sh
	@.venv/bin/python tests/test_licenses.py

wait-ci:
	@bash tests/wait_ci.sh

# DUTIES = \
# 	test-changelog \
# 	test-check \
# 	test-check-api \
# 	test-check-docs \
# 	test-check-quality \
# 	test-check-types \
# 	test-clean \
# 	test-coverage \
# 	test-docs \
# 	test-docs-deploy \
# 	test-format \
# 	test-help \
# 	test-lock \
# 	test-release \
# 	test-setup \
# 	test-test

# $(DUTIES):
# 	@cd tests/tmp && make $(subst test-,,$@)

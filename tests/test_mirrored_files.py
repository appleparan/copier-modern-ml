"""Assert that files mirrored between the repo root and `project/` stay identical.

Some files (CI workflows, pre-commit config, the release script, docs
requirements) intentionally exist both at the repo root -- where they apply to
this template repository itself -- and under `project/` -- where they are
copied byte-for-byte into every generated project. Copier only templates
`*.jinja` files, so these plain files must be kept in sync by hand; this test
fails fast when they drift.
"""

from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent

MIRRORED_PAIRS: list[tuple[str, str]] = [
    ('.pre-commit-config.yaml', 'project/.pre-commit-config.yaml'),
    ('.readthedocs.yml', 'project/.readthedocs.yaml'),
    ('scripts/release.sh', 'project/scripts/release.sh'),
    ('docs/requirements.txt', 'project/docs/requirements.txt'),
    (
        '.github/workflows/claude.yml',
        "project/{% if ci == 'github' %}.github{% endif %}/workflows/claude.yml",
    ),
    (
        '.github/workflows/publish-release.yml',
        "project/{% if ci == 'github' %}.github{% endif %}/workflows/publish-release.yml",
    ),
]


@pytest.mark.parametrize(('root_path', 'template_path'), MIRRORED_PAIRS)
def test_mirrored_file_content_matches(root_path: str, template_path: str) -> None:
    """Verify a root file and its `project/` mirror are byte-identical.

    Args:
        root_path: Path to the file at the repo root, relative to the repo root.
        template_path: Path to the mirrored file under `project/`, relative to
            the repo root.

    Raises:
        AssertionError: If the two files' contents differ.
    """
    root_file = REPO_ROOT / root_path
    template_file = REPO_ROOT / template_path

    assert root_file.is_file(), f'missing root file: {root_file}'
    assert template_file.is_file(), f'missing template file: {template_file}'

    root_content = root_file.read_bytes()
    template_content = template_file.read_bytes()

    assert root_content == template_content, (
        f'{root_path} and {template_path} have drifted; keep them identical'
    )

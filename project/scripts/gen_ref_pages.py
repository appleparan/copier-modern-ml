"""Generate the API reference pages for the Starlight documentation site.

This script walks the ``src/`` tree and renders one Markdown page per public
module with `griffe2md` into ``docs/content/docs/reference/``. It must be run
before `bun run build` (`make docs` runs both steps together). The generated
pages are committed to the repository because Read the Docs builds the
documentation site with Bun only, without a Python toolchain available to
regenerate them at build time.
"""

from __future__ import annotations

import logging
import shutil
import sys
from pathlib import Path

from griffe2md import ConfigDict, render_package_docs

logger = logging.getLogger(__name__)

ROOT_DIR = Path(__file__).resolve().parent.parent
SRC_DIR = ROOT_DIR / 'src'
REFERENCE_DIR = ROOT_DIR / 'docs' / 'content' / 'docs' / 'reference'

RENDER_CONFIG: ConfigDict = {
    'search_paths': [str(SRC_DIR)],
    'show_root_heading': False,
    'show_submodules': False,
    'heading_level': 2,
}


def should_skip_module(module_path: Path) -> bool:
    """Check whether a module should be excluded from the API reference.

    Args:
        module_path: Path to the module, relative to `SRC_DIR`, without suffix.

    Returns:
        True if the module lives under `tests/` or any of its path parts
        (other than a final `__init__`) is private (starts with an underscore).

    """
    parts = module_path.parts
    if parts and parts[0] == 'tests':
        return True
    return any(part.startswith('_') for part in parts[:-1]) or (
        parts[-1].startswith('_') and parts[-1] != '__init__'
    )


def module_identifier(path: Path) -> str:
    """Build the dotted module identifier griffe2md expects.

    Args:
        path: Path to a `.py` file under `SRC_DIR`.

    Returns:
        The dotted module path relative to `SRC_DIR`, with a trailing
        `__init__` dropped.

    """
    module_path = path.relative_to(SRC_DIR).with_suffix('')
    parts = module_path.parts
    if parts[-1] == '__init__':
        parts = parts[:-1]
    return '.'.join(parts)


def page_path(path: Path) -> Path:
    """Compute the output Markdown page path for a module.

    Args:
        path: Path to a `.py` file under `SRC_DIR`.

    Returns:
        Destination path under `REFERENCE_DIR`, with `__init__.py` mapped to
        `index.md`.

    """
    relative_md = path.relative_to(SRC_DIR).with_suffix('.md')
    if relative_md.name == '__init__.md':
        relative_md = relative_md.with_name('index.md')
    return REFERENCE_DIR / relative_md


def render_page(identifier: str) -> str:
    """Render a single API reference page.

    Args:
        identifier: Dotted module identifier to render docs for.

    Returns:
        Markdown content with a Starlight frontmatter title, followed by the
        griffe2md-rendered API documentation.

    """
    return f'---\ntitle: {identifier}\n---\n\n' + render_package_docs(identifier, RENDER_CONFIG)


def main() -> int:
    """Regenerate the API reference pages.

    Returns:
        0 on success, 1 if `SRC_DIR` does not exist.

    """
    if not SRC_DIR.is_dir():
        logger.error('Source directory not found: %s', SRC_DIR)
        return 1

    if REFERENCE_DIR.exists():
        shutil.rmtree(REFERENCE_DIR)
    REFERENCE_DIR.mkdir(parents=True, exist_ok=True)

    page_count = 0
    for path in sorted(SRC_DIR.rglob('*.py')):
        module_path = path.relative_to(SRC_DIR).with_suffix('')
        if should_skip_module(module_path):
            continue

        identifier = module_identifier(path)
        destination = page_path(path)
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_text(render_page(identifier), encoding='utf-8')
        page_count += 1

    logger.info('Wrote %d API reference page(s) to %s', page_count, REFERENCE_DIR)
    return 0


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO)
    sys.exit(main())

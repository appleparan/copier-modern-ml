"""Generate the code reference pages and navigation.

This script creates API documentation pages for Python modules and builds navigation.
"""

from pathlib import Path

import mkdocs_gen_files

REF_DOCS_DIR_NAME = 'reference'


def should_skip_module(module_path: Path) -> bool:
    """Check if a module should be skipped in documentation.

    Args:
        module_path: The relative module path

    Returns:
        bool: True if the module should be skipped
    """
    # Skip tests directory and private modules (starting with underscore)
    first_dir = str(module_path).split('/')[0] if '/' in str(module_path) else ''
    return first_dir == 'tests' or module_path.name.startswith('_')


def process_module(
    path: Path, src_dir: Path
) -> tuple[tuple[str, ...], Path, Path] | None:
    """Process a single Python module for documentation.

    Args:
        path: The path to the Python file
        src_dir: The source directory containing Python modules
        nav: The navigation object

    Returns:
        tuple: (parts, doc_path, full_doc_path) for the processed module
        or None if the module should be skipped
    """
    module_path = path.relative_to(src_dir).with_suffix('')

    # Skip modules that should not be included
    if should_skip_module(module_path):
        return None

    doc_path = path.relative_to(src_dir).with_suffix('.md')
    full_doc_path = Path(REF_DOCS_DIR_NAME, doc_path)

    parts = tuple(module_path.parts)

    # Handle __init__.py files
    if parts[-1] == '__init__':
        parts = parts[:-1]
        doc_path = doc_path.with_name('index.md')
        full_doc_path = full_doc_path.with_name('index.md')

    return parts, doc_path, full_doc_path


def generate_doc_file(
    full_doc_path: Path, parts: tuple[str, ...], path: Path, root_dir: Path
) -> None:
    """Generate a documentation file for a module.

    Args:
        full_doc_path: The full path for the documentation file
        parts: The parts of the module path
        path: The original path to the Python file
        root_dir: The root directory of the project
    """
    with mkdocs_gen_files.open(full_doc_path, 'w') as fd:
        ident = '.'.join(parts)
        # Add YAML frontmatter with title
        fd.write(f'---\ntitle: {ident}\n---\n\n::: {ident}')

    # Set edit path for "edit this page" links
    mkdocs_gen_files.set_edit_path(full_doc_path, path.relative_to(root_dir))


def main() -> None:
    """Main function to generate API documentation."""
    nav = mkdocs_gen_files.Nav()

    # Find project root and source directories
    root_dir = Path(__file__).parent.parent
    src_dir = root_dir / 'src'

    # Process each Python file
    for path in sorted(src_dir.rglob('*.py')):
        result = process_module(path, src_dir)
        if result is None:
            continue

        parts, doc_path, full_doc_path = result

        # Add to navigation
        nav[parts] = doc_path.as_posix()

        # Generate the documentation file
        generate_doc_file(full_doc_path, parts, path, root_dir)

    # Write the navigation summary
    summary_path = f'{REF_DOCS_DIR_NAME}/SUMMARY.md'
    with mkdocs_gen_files.open(summary_path, 'w') as nav_file:
        nav_file.writelines(nav.build_literate_nav())


main()

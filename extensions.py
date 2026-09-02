"""Custom Jinja2 filters and globals used by `copier.yml`.

Provides the `slugify`, `git_user_name` and `git_user_email` filters plus the
`current_year` global, wired into copier via `_jinja_extensions`.
"""

from __future__ import annotations

import re
import subprocess
import unicodedata
from datetime import UTC, datetime
from typing import TYPE_CHECKING

from jinja2.ext import Extension

if TYPE_CHECKING:
    from jinja2 import Environment


def git_user_name(default: str) -> str:
    """Return the local git user.name, falling back to `default`.

    Args:
        default: Value to return when git has no configured user.name.

    Returns:
        The configured `git config user.name`, or `default` if unset.
    """
    return subprocess.getoutput('git config user.name').strip() or default


def git_user_email(default: str) -> str:
    """Return the local git user.email, falling back to `default`.

    Args:
        default: Value to return when git has no configured user.email.

    Returns:
        The configured `git config user.email`, or `default` if unset.
    """
    return subprocess.getoutput('git config user.email').strip() or default


def slugify(value: str, separator: str = '-') -> str:
    """Convert a string into an ASCII slug.

    Normalizes unicode to ASCII, lowercases it, strips characters that are
    not word characters, whitespace or hyphens, then collapses runs of
    hyphens/underscores/whitespace into a single `separator`.

    Args:
        value: The string to slugify.
        separator: The character used to join slug segments.

    Returns:
        The slugified string.
    """
    value = (
        unicodedata.normalize('NFKD', str(value))
        .encode('ascii', 'ignore')
        .decode('ascii')
    )
    value = re.sub(r'[^\w\s-]', '', value.lower())
    return re.sub(r'[-_\s]+', separator, value).strip('-_')


class GitExtension(Extension):
    """Jinja2 extension registering the `git_user_name`/`git_user_email` filters."""

    def __init__(self, environment: Environment) -> None:
        """Register the git-derived filters on the Jinja2 environment.

        Args:
            environment: The Jinja2 environment to extend.
        """
        super().__init__(environment)
        environment.filters['git_user_name'] = git_user_name
        environment.filters['git_user_email'] = git_user_email


class SlugifyExtension(Extension):
    """Jinja2 extension registering the `slugify` filter."""

    def __init__(self, environment: Environment) -> None:
        """Register the `slugify` filter on the Jinja2 environment.

        Args:
            environment: The Jinja2 environment to extend.
        """
        super().__init__(environment)
        environment.filters['slugify'] = slugify


class CurrentYearExtension(Extension):
    """Jinja2 extension exposing the current year as a template global."""

    def __init__(self, environment: Environment) -> None:
        """Register the `current_year` global on the Jinja2 environment.

        Args:
            environment: The Jinja2 environment to extend.
        """
        super().__init__(environment)
        environment.globals['current_year'] = datetime.now(tz=UTC).year

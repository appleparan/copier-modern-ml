from {{ cookiecutter.project_slug }} import __version__


def test_version():  # noqa: ANN201
    assert __version__ == "{{ cookiecutter.version }}"

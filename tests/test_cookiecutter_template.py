"""Write tests inspired by https://til.simonwillison.net/cookiecutter/pytest-for-cookiecutter."""
from cookiecutter.main import cookiecutter
import pathlib

TEMPLATE_DIRECTORY = str(pathlib.Path(__file__).parent.parent)


def test_static_and_templates(tmpdir):
    generate(
        tmpdir,
        {
            "project_name": "foo",
            "description": "blah",
            "version": "0.0.1",
            "full_name": "NAME123",
            "email": "myemail@email.address",
            "license": "Apache Software License 2.0",
            "configs_folder": "cfg1",
            "data_folder": "dt1",
            "example_folder": "ex1",
            "models_folder": "md1",
            "notebooks_folder": "nb1",
            "references_folder": "ref1",
            "reports_folder": "rep1",
            
        },
    )
    assert paths(tmpdir) == {
        "foo",
        "foo/.github",
        "foo/.github/workflows",
        "foo/.github/workflows/pytest.yml",
        "foo/.gitignore",
        "foo/mkdocs.yml",
        "foo/docs",
        "foo/cfg1",
        "foo/dt1",
        "foo/ex1",
        "foo/md1",
        "foo/nb1",
        "foo/ref1",
        "foo/rep1",
        "foo/src/",
        "foo/src/foo/__init__.py",
        "foo/src/foo/cli.py",
        "foo/src/tests/__init__.py",
        "foo/src/tests/test_foo.py",
        "foo/README.md",
        "foo/setup.py",
        "foo/setup.cfg",
        "foo/scripts/gen_ref_pages.py",
    }
    assert (
        'package_data={\n        "datasette_foo": ["static/*", "templates/*"]\n    }'
    ) in read_setup_py(tmpdir)


def test_no_static_or_templates(tmpdir):
    generate(tmpdir, {"plugin_name": "foo", "description": "blah"})
    assert "datasette-foo/datasette_foo/static" not in paths(tmpdir)
    assert "datasette-foo/datasette_foo/templates" not in paths(tmpdir)
    assert "package_data={" not in read_setup_py(tmpdir)


def test_static_but_no_templates(tmpdir):
    generate(
        tmpdir,
        {"plugin_name": "foo", "description": "blah", "include_static_directory": "y"},
    )
    assert "datasette-foo/datasette_foo/static" in paths(tmpdir)
    assert "datasette-foo/datasette_foo/templates" not in paths(tmpdir)
    assert (
        'package_data={\n        "datasette_foo": ["static/*"]\n    }'
    ) in read_setup_py(tmpdir)


def test_templates_but_no_static(tmpdir):
    generate(
        tmpdir,
        {
            "plugin_name": "foo",
            "description": "blah",
            "include_templates_directory": "y",
        },
    )
    assert "datasette-foo/datasette_foo/static" not in paths(tmpdir)
    assert "datasette-foo/datasette_foo/templates" in paths(tmpdir)
    assert (
        'package_data={\n        "datasette_foo": ["templates/*"]\n    }'
    ) in read_setup_py(tmpdir)


def generate(directory, context):
    cookiecutter(
        template=TEMPLATE_DIRECTORY,
        output_dir=str(directory),
        no_input=True,
        extra_context=context,
    )


def read_setup_py(tmpdir):
    return (tmpdir / "datasette-foo" / "setup.py").read_text("utf-8")


def paths(directory):
    paths = list(pathlib.Path(directory).glob("**/*"))
    paths = [r.relative_to(directory) for r in paths]
    return {str(f) for f in paths if str(f) != "."}

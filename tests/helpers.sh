generate() {
  local src="$1"
  local dst="$2"
  shift 2
  uvx --with copier_templates_extensions copier copy -f --trust -r HEAD "$src" "$dst" \
    -d project_name="Modern Python Machine Learning Workflow Package" \
    -d project_slug="modern_template" \
    -d project_description='Testing template' \
    -d repo_url="https://example.com" \
    -d version="0.1.0" \
    -d author_fullname="Author123" \
    -d author_email="username123@user.emailaddress" \
    -d copyright_holder="Author123" \
    -d copyright_holder_email="username123@user.emailaddress" \
    -d copyright_license="MIT License" \
    -d package=yes \
    -d system_certs=no \
    -d allow_insecure_host=no \
    -d ci="github" \
    -d create_directories=yes \
    "$@"
}

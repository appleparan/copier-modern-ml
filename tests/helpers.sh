generate() {
  rye run copier copy -f --trust -r HEAD "$1" "$2" \
    -d project_name="Modern Python Machine Learning Workflow Package" \
    -d project_slug="modern_ml_template" \
    -d project_description='Testing template' \
    -d version="0.1.0" \
    -d author_fullname="Author123" \
    -d author_email="username123@user.emailaddress" \
    -d copyright_license="MIT License" \
    -d virtual="No" \
    -d ci="github"
}
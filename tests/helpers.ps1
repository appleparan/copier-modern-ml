function Generate {
    param(
        [string]$SourceDir,
        [string]$TargetDir
    )

    & uvx --with copier_templates_extensions copier copy -f --trust -r HEAD $SourceDir $TargetDir `
        -d project_name="Modern Python Machine Learning Workflow Package" `
        -d project_slug="modern_ml_template_testing" `
        -d project_description="Testing template" `
        -d repo_url="https://example.com" `
        -d version="0.1.0" `
        -d author_fullname="Author123" `
        -d author_email="username123@user.emailaddress" `
        -d copyright_license="MIT License" `
        -d package="yes" `
        -d native_tls="no" `
        -d allow_insecure_tls="no" `
        -d ci="github"
}

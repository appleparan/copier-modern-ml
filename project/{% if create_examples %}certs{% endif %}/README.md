# Corporate CA certificates

Put your organization's root CA certificate(s) here as `*.crt` files (PEM
format).

They are copied into the Docker image during build and installed into the
system trust store with `update-ca-certificates`, so that `uv`, Python's
`requests`/`httpx`, and any other tool relying on the system certificate
store can verify TLS connections through a corporate TLS-inspecting proxy.

These files are public keys (certificates, not private keys), so they are
safe to commit to version control.

See `docs/enterprise-network.md` for the full explanation.

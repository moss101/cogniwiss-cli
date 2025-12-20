# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security issue, please report it responsibly.

### How to Report

**DO NOT** open a public GitHub issue for security vulnerabilities.

Instead, please email us at: **security@cogniwiss.ai**

Include the following in your report:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Any suggested fixes (optional)

### Response Timeline

- **Initial response**: Within 48 hours
- **Status update**: Within 7 days
- **Resolution target**: Within 30 days (depending on severity)

### What to Expect

1. We will acknowledge receipt of your report
2. We will investigate and validate the issue
3. We will work on a fix and coordinate disclosure
4. We will credit you in the release notes (unless you prefer anonymity)

## Security Best Practices

### Verifying Downloads

All releases include SHA256 checksums. Always verify your download:

```bash
# Download checksums
curl -fsSL https://github.com/cogniwiss/cogniwiss-cli-dist/releases/latest/download/checksums.txt -o checksums.txt

# Verify binary
sha256sum -c checksums.txt 2>/dev/null | grep cogniwiss
```

### Homebrew Verification

Homebrew formulas include SHA256 verification automatically. The formula at `cogniwiss/tap/cogniwiss` is the official source.

### npm Verification

npm packages are published from our verified CI/CD pipeline. Check the package page for provenance information:
https://www.npmjs.com/package/cogniwiss

## Binary Integrity

- All binaries are built in isolated CI environments
- Build logs are available for audit
- No post-install scripts that download additional content
- No telemetry or external network calls without user consent

## Scope

This security policy covers:
- The Cogniwiss CLI binary
- The npm package
- The Homebrew formula
- The curl installer script

For security issues in the Cogniwiss platform or API, please contact security@cogniwiss.ai separately.

## Acknowledgments

We thank the security research community for helping keep Cogniwiss CLI secure. Contributors will be acknowledged in our release notes.

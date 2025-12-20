# Native Binaries

This directory contains the platform-specific native binaries for Cogniwiss CLI.

## Supported Platforms

| Binary Name | Platform | Architecture |
|-------------|----------|--------------|
| `cogniwiss-darwin-arm64` | macOS | Apple Silicon (M1/M2/M3) |
| `cogniwiss-darwin-x64` | macOS | Intel x64 |
| `cogniwiss-linux-x64` | Linux | x64/amd64 |
| `cogniwiss-win-x64.exe` | Windows | x64 |

## How Binaries Are Built

Binaries are built from the **private** Cogniwiss CLI source repository using [PyInstaller](https://pyinstaller.org/):

```bash
# Example build command (run in private repo)
pyinstaller --onefile --name cogniwiss cli/main.py
```

## CI/CD Pipeline

1. **Private repo** builds binaries for all platforms via GitHub Actions
2. **Repository dispatch** sends binaries to this public repo
3. **Release workflow** publishes binaries to GitHub Releases + npm

## For Local Development

If you need to test the npm package locally with actual binaries:

1. Build binaries from the private repo
2. Place them in this directory with correct naming
3. Run `npm pack` to create a tarball
4. Install locally: `npm install -g ./cogniwiss-0.1.0.tgz`

## Security Notes

- All binaries are code-signed (where applicable)
- SHA256 checksums are published with each release
- Checksums are verified during installation

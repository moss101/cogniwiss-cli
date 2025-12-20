# Cogniwiss CLI

AI Code Intelligence CLI - The intelligent coding assistant for your terminal.

## Installation

### macOS / Linux (curl)

```bash
curl -fsSL https://raw.githubusercontent.com/cogniwiss/cogniwiss-cli-dist/main/install/install.sh | sh
```

### macOS (Homebrew)

```bash
brew install cogniwiss/tap/cogniwiss
```

### npm / npx

```bash
# Global install
npm install -g cogniwiss
cogniwiss

# Or run directly with npx
npx cogniwiss
```

## Usage

```bash
# Launch interactive mode
cogniwiss

# Get help
cogniwiss --help

# Run specific commands
cogniwiss <command> [options]
```

## Supported Platforms

| Platform | Architecture | Status |
|----------|--------------|--------|
| macOS    | Apple Silicon (M1/M2/M3) | ✅ |
| macOS    | Intel x64    | ✅ |
| Linux    | x64/amd64    | ✅ |
| Windows  | x64          | ✅ |

## Verification

All binaries are verified with SHA256 checksums. To manually verify:

```bash
# Download checksum file
curl -fsSL https://github.com/cogniwiss/cogniwiss-cli-dist/releases/latest/download/checksums.txt

# Verify your binary
shasum -a 256 $(which cogniwiss)
```

## Updating

### curl
Re-run the install command - it will replace the existing binary.

### Homebrew
```bash
brew upgrade cogniwiss
```

### npm
```bash
npm update -g cogniwiss
```

## Uninstalling

### curl
```bash
rm $(which cogniwiss)
```

### Homebrew
```bash
brew uninstall cogniwiss
```

### npm
```bash
npm uninstall -g cogniwiss
```

## Troubleshooting

### "command not found: cogniwiss"

Ensure the install directory is in your PATH:

```bash
# For ~/.local/bin (default for curl install)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Permission denied

If the binary isn't executable:

```bash
chmod +x $(which cogniwiss)
```

### npm - Binary not found

Try reinstalling:

```bash
npm uninstall -g cogniwiss
npm install -g cogniwiss
```

## Requirements

- **No Python required** - Binaries are self-contained
- **No Node.js required** for curl/Homebrew installs
- Node.js 14+ required only for npm installation method

## Security

See [SECURITY.md](SECURITY.md) for vulnerability reporting and security practices.

## License

MIT - See [LICENSE](LICENSE)

## Links

- [Documentation](https://docs.cogniwiss.ai)
- [Changelog](https://github.com/cogniwiss/cogniwiss-cli-dist/releases)
- [Issue Tracker](https://github.com/cogniwiss/cogniwiss-cli-dist/issues)

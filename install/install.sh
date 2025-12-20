#!/bin/sh
# Cogniwiss CLI Installer
# 
# Install via: curl -fsSL https://cogniwiss.ai/install.sh | sh
#
# This script:
# 1. Detects OS and architecture
# 2. Downloads the correct binary from GitHub Releases
# 3. Installs to ~/.local/bin or /usr/local/bin
# 4. Verifies SHA256 checksum
#
# Requirements: curl, tar (or unzip on Windows), shasum/sha256sum

set -e

# Configuration
REPO="cogniwiss/cogniwiss-cli-dist"
INSTALL_NAME="cogniwiss"
VERSION="${COGNIWISS_VERSION:-latest}"

# Colors (disable if not interactive)
if [ -t 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  NC='\033[0m' # No Color
else
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  NC=''
fi

info() {
  printf "${BLUE}info${NC}: %s\n" "$1"
}

success() {
  printf "${GREEN}success${NC}: %s\n" "$1"
}

warn() {
  printf "${YELLOW}warn${NC}: %s\n" "$1"
}

error() {
  printf "${RED}error${NC}: %s\n" "$1" >&2
  exit 1
}

# Detect OS
detect_os() {
  case "$(uname -s)" in
    Darwin*)  echo "darwin" ;;
    Linux*)   echo "linux" ;;
    MINGW*|MSYS*|CYGWIN*) echo "win" ;;
    *)        error "Unsupported operating system: $(uname -s)" ;;
  esac
}

# Detect architecture
detect_arch() {
  case "$(uname -m)" in
    x86_64|amd64)  echo "x64" ;;
    arm64|aarch64) echo "arm64" ;;
    *)             error "Unsupported architecture: $(uname -m)" ;;
  esac
}

# Get latest release version from GitHub
get_latest_version() {
  curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | \
    grep '"tag_name"' | \
    sed -E 's/.*"tag_name": *"([^"]+)".*/\1/'
}

# Verify SHA256 checksum
verify_checksum() {
  local file="$1"
  local expected="$2"
  
  if command -v sha256sum >/dev/null 2>&1; then
    actual=$(sha256sum "$file" | awk '{print $1}')
  elif command -v shasum >/dev/null 2>&1; then
    actual=$(shasum -a 256 "$file" | awk '{print $1}')
  else
    warn "Neither sha256sum nor shasum found. Skipping checksum verification."
    return 0
  fi
  
  if [ "$actual" != "$expected" ]; then
    error "Checksum verification failed.\nExpected: $expected\nActual:   $actual"
  fi
  
  info "Checksum verified"
}

# Determine install directory
get_install_dir() {
  # Prefer ~/.local/bin if it exists or can be created
  local user_bin="${HOME}/.local/bin"
  local system_bin="/usr/local/bin"
  
  if [ -d "$user_bin" ] && [ -w "$user_bin" ]; then
    echo "$user_bin"
  elif [ -w "$system_bin" ]; then
    echo "$system_bin"
  elif mkdir -p "$user_bin" 2>/dev/null; then
    echo "$user_bin"
  else
    echo "$system_bin"
  fi
}

# Check if directory is in PATH
check_path() {
  local dir="$1"
  case ":$PATH:" in
    *":$dir:"*) return 0 ;;
    *)          return 1 ;;
  esac
}

# Main installation
main() {
  info "Installing Cogniwiss CLI..."
  
  OS=$(detect_os)
  ARCH=$(detect_arch)
  
  # Linux only supports x64
  if [ "$OS" = "linux" ] && [ "$ARCH" != "x64" ]; then
    error "Linux only supports x64 architecture. Detected: $ARCH"
  fi
  
  info "Detected platform: ${OS}-${ARCH}"
  
  # Get version
  if [ "$VERSION" = "latest" ]; then
    VERSION=$(get_latest_version)
    if [ -z "$VERSION" ]; then
      error "Failed to fetch latest version"
    fi
  fi
  
  info "Installing version: ${VERSION}"
  
  # Construct download URLs
  EXTENSION=""
  if [ "$OS" = "win" ]; then
    EXTENSION=".exe"
  fi
  
  BINARY_NAME="cogniwiss-${OS}-${ARCH}${EXTENSION}"
  DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${BINARY_NAME}"
  CHECKSUM_URL="https://github.com/${REPO}/releases/download/${VERSION}/checksums.txt"
  
  # Create temp directory
  TMP_DIR=$(mktemp -d)
  trap "rm -rf '$TMP_DIR'" EXIT
  
  # Download binary
  info "Downloading ${BINARY_NAME}..."
  if ! curl -fsSL -o "${TMP_DIR}/${BINARY_NAME}" "$DOWNLOAD_URL"; then
    error "Failed to download binary from: $DOWNLOAD_URL"
  fi
  
  # Download and verify checksum
  info "Verifying checksum..."
  if curl -fsSL -o "${TMP_DIR}/checksums.txt" "$CHECKSUM_URL" 2>/dev/null; then
    EXPECTED_CHECKSUM=$(grep "$BINARY_NAME" "${TMP_DIR}/checksums.txt" | awk '{print $1}')
    if [ -n "$EXPECTED_CHECKSUM" ]; then
      verify_checksum "${TMP_DIR}/${BINARY_NAME}" "$EXPECTED_CHECKSUM"
    else
      warn "Checksum not found for ${BINARY_NAME}. Skipping verification."
    fi
  else
    warn "Could not download checksums. Skipping verification."
  fi
  
  # Determine install location
  INSTALL_DIR=$(get_install_dir)
  INSTALL_PATH="${INSTALL_DIR}/${INSTALL_NAME}"
  
  # Install binary
  if [ -w "$INSTALL_DIR" ]; then
    mv "${TMP_DIR}/${BINARY_NAME}" "$INSTALL_PATH"
    chmod +x "$INSTALL_PATH"
  else
    info "Installing to ${INSTALL_DIR} requires elevated permissions..."
    sudo mv "${TMP_DIR}/${BINARY_NAME}" "$INSTALL_PATH"
    sudo chmod +x "$INSTALL_PATH"
  fi
  
  success "Installed to ${INSTALL_PATH}"
  
  # Check PATH
  if ! check_path "$INSTALL_DIR"; then
    warn "${INSTALL_DIR} is not in your PATH."
    echo ""
    echo "Add it to your shell configuration:"
    echo ""
    case "$SHELL" in
      */zsh)  echo "  echo 'export PATH=\"${INSTALL_DIR}:\$PATH\"' >> ~/.zshrc" ;;
      */bash) echo "  echo 'export PATH=\"${INSTALL_DIR}:\$PATH\"' >> ~/.bashrc" ;;
      *)      echo "  export PATH=\"${INSTALL_DIR}:\$PATH\"" ;;
    esac
    echo ""
  fi
  
  # Verify installation
  if command -v cogniwiss >/dev/null 2>&1 || [ -x "$INSTALL_PATH" ]; then
    success "Cogniwiss CLI installed successfully!"
    echo ""
    echo "Get started:"
    echo "  ${INSTALL_NAME} --help"
    echo "  ${INSTALL_NAME}          # Launch interactive mode"
  else
    warn "Installation complete, but 'cogniwiss' command not found in PATH."
    echo "Try: ${INSTALL_PATH} --help"
  fi
}

main "$@"

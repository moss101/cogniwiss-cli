# typed: false
# frozen_string_literal: true

# Homebrew formula for Cogniwiss CLI
# Install via: brew install cogniwiss/tap/cogniwiss
class Cogniwiss < Formula
  desc "AI Code Intelligence CLI"
  homepage "https://cogniwiss.ai"
  version "0.1.0"
  license "MIT"

  # Platform-specific binary downloads
  on_macos do
    on_arm do
      url "https://github.com/cogniwiss/cogniwiss-cli-dist/releases/download/v#{version}/cogniwiss-darwin-arm64"
      sha256 "PLACEHOLDER_SHA256_DARWIN_ARM64"
    end
    on_intel do
      url "https://github.com/cogniwiss/cogniwiss-cli-dist/releases/download/v#{version}/cogniwiss-darwin-x64"
      sha256 "PLACEHOLDER_SHA256_DARWIN_X64"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/cogniwiss/cogniwiss-cli-dist/releases/download/v#{version}/cogniwiss-linux-x64"
      sha256 "PLACEHOLDER_SHA256_LINUX_X64"
    end
  end

  def install
    # Determine the correct binary name based on platform
    binary_name = if OS.mac?
                    if Hardware::CPU.arm?
                      "cogniwiss-darwin-arm64"
                    else
                      "cogniwiss-darwin-x64"
                    end
                  else
                    "cogniwiss-linux-x64"
                  end

    # The downloaded file may have the platform-specific name or be renamed
    # Handle both cases
    downloaded_file = Dir.glob("cogniwiss*").first || binary_name
    
    # Install binary
    bin.install downloaded_file => "cogniwiss"
  end

  def caveats
    <<~EOS
      Cogniwiss CLI has been installed!

      Get started:
        cogniwiss --help
        cogniwiss          # Launch interactive mode

      Documentation: https://docs.cogniwiss.ai
    EOS
  end

  test do
    # Basic smoke test - verify binary runs
    assert_match "cogniwiss", shell_output("#{bin}/cogniwiss --version", 0)
  end
end

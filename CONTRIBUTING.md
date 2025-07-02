# Contributing to gritql-flake

## Development Setup

1. Clone the repository:
```bash
git clone https://github.com/schickling/gritql-flake
cd gritql-flake
```

2. Test the flake:
```bash
nix flake check
nix run . -- --version
```

## Updating GritQL Version

To update to a new GritQL release:

1. Find the latest release at https://github.com/getgrit/gritql/releases
2. Update the `version` in `flake.nix`
3. Update the SHA256 hashes for each platform:

```bash
# Get SHA256 for each platform
nix-prefetch-url https://github.com/getgrit/gritql/releases/download/v{VERSION}/grit-aarch64-apple-darwin.tar.gz
nix-prefetch-url https://github.com/getgrit/gritql/releases/download/v{VERSION}/grit-x86_64-apple-darwin.tar.gz
nix-prefetch-url https://github.com/getgrit/gritql/releases/download/v{VERSION}/grit-x86_64-unknown-linux-gnu.tar.gz
nix-prefetch-url https://github.com/getgrit/gritql/releases/download/v{VERSION}/grit-aarch64-unknown-linux-gnu.tar.gz
```

4. Update the hashes in `flake.nix`
5. Test the updated flake
6. Commit and push changes

## Architecture

The flake uses pre-built binaries from GritQL releases rather than building from source. This approach:
- Provides faster installation times
- Ensures compatibility with official releases
- Simplifies maintenance

### Platform Support

The flake supports:
- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin` (Intel macOS)
- `aarch64-darwin` (Apple Silicon)

### Key Components

- **Binary fetching**: Uses `fetchurl` to download platform-specific tarballs
- **Linux patching**: Uses `autoPatchelfHook` on Linux to fix dynamic library paths
- **Installation**: Extracts and installs the `grit` binary to the Nix store
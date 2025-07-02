# gritql-flake

A Nix flake for [GritQL](https://github.com/getgrit/gritql) - a query language for code.

## Installation

### Using Nix with Flakes

Add to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    gritql.url = "github:schickling/gritql-flake";
  };

  outputs = { self, nixpkgs, gritql }: {
    # Your outputs here
  };
}
```

### Running directly

```bash
# Run grit directly
nix run github:schickling/gritql-flake -- --help

# Enter a shell with grit available
nix develop github:schickling/gritql-flake
```

### Installing in NixOS or Home Manager

```nix
environment.systemPackages = [
  gritql.packages.${system}.default
];
```

## Features

- Pre-built binaries for optimal installation speed
- Support for all major platforms:
  - x86_64-linux
  - aarch64-linux
  - x86_64-darwin (Intel macOS)
  - aarch64-darwin (Apple Silicon)
- Automatic dependency management

## Usage

Once installed, you can use GritQL:

```bash
# Check for pattern violations
grit check

# List available patterns
grit list

# Apply a pattern
grit apply <pattern-name>

# Get help
grit --help
```

## License

This flake is provided as-is. GritQL itself is licensed under the MIT License.
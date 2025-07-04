# gritql-flake

Nix flake for [GritQL](https://github.com/getgrit/gritql) - a query language for code.

## Quick Start

```bash
# Run grit directly
nix run github:schickling/gritql-flake -- --help

# Use in your project
nix develop github:schickling/gritql-flake
```

## Add to Your Project

### Using Overlay (Recommended)

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    gritql.url = "github:schickling/gritql-flake";
  };

  outputs = { self, nixpkgs, gritql, ... }: {
    nixosConfigurations.example = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ gritql.overlays.default ];
          environment.systemPackages = [ pkgs.gritql ];
        })
      ];
    };
  };
}
```

### In Dev Shell

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gritql.url = "github:schickling/gritql-flake";
  };

  outputs = { self, nixpkgs, flake-utils, gritql }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ gritql.overlays.default ];
        };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [ 
            pkgs.gritql
            # your other dev dependencies
          ];
        };
      });
}
```

Then run `nix develop` to enter the shell with `grit` available.

### In Home Manager

```nix
# After adding the overlay
home.packages = [ pkgs.gritql ];
```

## Build Approach

This flake builds GritQL from source using the Rust toolchain, providing:
- Reproducible builds across platforms
- Direct integration with Nix ecosystem
- Full control over build configuration
- Source transparency and security

The build process:
1. Fetches latest source code from [honeycombio/gritql](https://github.com/honeycombio/gritql) main branch
2. Includes git submodules for tree-sitter language support
3. Builds using Rust 1.82.0 as specified by the project
4. Produces the `grit` CLI binary

## What is GritQL?

GritQL is a declarative query language for searching and transforming code. Use it to:
- Search for code patterns across your codebase
- Automate code migrations and refactoring
- Enforce coding standards

Learn more at [grit.io](https://grit.io)
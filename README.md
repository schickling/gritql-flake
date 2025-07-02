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

### In `flake.nix` (dev shell)

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
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            gritql.packages.${system}.default
            # your other dev dependencies
          ];
        };
      });
}
```

Then run `nix develop` to enter the shell with `grit` available.

### In NixOS configuration

```nix
environment.systemPackages = [
  inputs.gritql.packages.${pkgs.system}.default
];
```

### In Home Manager

```nix
home.packages = [
  inputs.gritql.packages.${pkgs.system}.default
];
```

## What is GritQL?

GritQL is a declarative query language for searching and transforming code. Use it to:
- Search for code patterns across your codebase
- Automate code migrations and refactoring
- Enforce coding standards

Learn more at [grit.io](https://grit.io)
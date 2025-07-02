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

### In `flake.nix`

```nix
{
  inputs = {
    gritql.url = "github:schickling/gritql-flake";
  };

  outputs = { self, gritql, ... }: {
    # Use gritql.packages.${system}.default
  };
}
```

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
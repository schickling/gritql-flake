{
  description = "Nix flake for GritQL - a query language for code";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      # Define the package builder as a function
      mkGritql = pkgs: pkgs.rustPlatform.buildRustPackage rec {
        pname = "gritql";
        version = "0.1.0-alpha.1743007075";
        
        src = pkgs.fetchFromGitHub {
          owner = "honeycombio";
          repo = "gritql";
          rev = "v${version}";
          sha256 = "sha256-ru8XnXiwwrlrGFtj8kIXUGBS6jnazLIQklZotTPItSw=";
          fetchSubmodules = true;
        };
        
        cargoHash = "sha256-tvwxoqPpVoR7oZJuVfssrwica2dVVs2DyvD9mzW+NwU=";
        
        # Only build the grit binary from the cli_bin crate without default features
        cargoBuildFlags = [ "-p" "grit" "--no-default-features" ];
        
        # Use the specific Rust version from rust-toolchain.toml
        RUSTC_VERSION = "1.82.0";
        
        # Build inputs may be needed for certain dependencies
        nativeBuildInputs = with pkgs; [
          pkg-config
          perl
        ];
        
        buildInputs = with pkgs; [
          # Common build dependencies for Rust projects
          openssl
        ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
          pkgs.darwin.apple_sdk.frameworks.Security
          pkgs.darwin.apple_sdk.frameworks.SystemConfiguration
        ];
        
        # Skip tests for now to speed up build
        doCheck = false;
        
        meta = with pkgs.lib; {
          description = "GritQL is a query language for code";
          homepage = "https://github.com/honeycombio/gritql";
          license = licenses.mit;
          maintainers = [ ];
          mainProgram = "grit";
          platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
        };
      };
    in
    {
      # Provide an overlay that adds gritql to nixpkgs
      overlays.default = final: prev: {
        gritql = mkGritql final;
      };
    }
    // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        gritql = mkGritql pkgs;
      in
      {
        # Direct package access for simple usage
        packages = {
          default = gritql;
          gritql = gritql;
        };
        
        devShells.default = pkgs.mkShell {
          buildInputs = [ gritql ];
          
          shellHook = ''
            echo "GritQL is available. Try running: grit --help"
          '';
        };
      });
}
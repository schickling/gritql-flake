{
  description = "Nix flake for GritQL - a query language for code";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        gritql = pkgs.stdenv.mkDerivation rec {
          pname = "gritql";
          version = "0.1.0-alpha.1743007075";
          
          src = 
            if pkgs.stdenv.isDarwin then
              if pkgs.stdenv.isAarch64 then
                pkgs.fetchurl {
                  url = "https://github.com/getgrit/gritql/releases/download/v${version}/grit-aarch64-apple-darwin.tar.gz";
                  sha256 = "1wvb0sm3s6ny1n8rniba5sk92sz591z9nakgr0ssx687m7pcgf3s";
                }
              else
                pkgs.fetchurl {
                  url = "https://github.com/getgrit/gritql/releases/download/v${version}/grit-x86_64-apple-darwin.tar.gz";
                  sha256 = "03h1aav549n53x17k9xzqw0sqnhsad9sybr8jghmhaz7rwqz00mm";
                }
            else if pkgs.stdenv.isLinux then
              if pkgs.stdenv.isAarch64 then
                pkgs.fetchurl {
                  url = "https://github.com/getgrit/gritql/releases/download/v${version}/grit-aarch64-unknown-linux-gnu.tar.gz";
                  sha256 = "0w28jg8ffz1fccvjqnf7lxhh5y3qk8klv3q1dlw1cmsr8mf42dwf";
                }
              else
                pkgs.fetchurl {
                  url = "https://github.com/getgrit/gritql/releases/download/v${version}/grit-x86_64-unknown-linux-gnu.tar.gz";
                  sha256 = "0j9i2r63s7bqdiax15n9cgbcczq7jjng19ram62hxjiqlm0ldcwl";
                }
            else
              throw "Unsupported platform";
          
          nativeBuildInputs = with pkgs; 
            lib.optionals stdenv.isLinux [ autoPatchelfHook ];
          
          buildInputs = with pkgs; 
            lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];
          
          unpackPhase = ''
            tar -xzf $src
          '';
          
          installPhase = ''
            runHook preInstall
            
            install -D -m755 */grit $out/bin/grit
            
            runHook postInstall
          '';
          
          meta = with pkgs.lib; {
            description = "GritQL is a query language for code";
            homepage = "https://github.com/getgrit/gritql";
            license = licenses.mit;
            maintainers = [ ];
            mainProgram = "grit";
            platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
          };
        };
      in
      {
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
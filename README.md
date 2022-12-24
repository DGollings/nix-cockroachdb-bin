# CockroachDB binary
https://github.com/cockroachdb/cockroach

# Example usage:

flake.nix
``` nix
{
  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      flake-utils.url = "github:numtide/flake-utils";
      cockroachdb-bin.url = "github:DGollings/nix-cockroachdb-bin";
    };

  outputs = { self, nixpkgs, flake-utils, cockroachdb-bin }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = [
            cockroachdb-bin.packages.${system}.cockroachdb-bin
          ];
        };
      });
}
```

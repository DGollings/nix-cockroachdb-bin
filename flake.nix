{
  description = "CockroachDB binary";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-22.11";

  outputs = { self, nixpkgs }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = "21.2.4";

      # System types to support.
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

    in
    {

      packages = forAllSystems (system:
        with import nixpkgs { system = "x86_64-linux"; };
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          cockroachdb-bin = stdenv.mkDerivation {
            pname = "cockroachdb-bin";
            version = version;

            src = fetchurl {
              url = "https://binaries.cockroachdb.com/cockroach-v${version}.linux-amd64.tgz";
              sha256 = "0f9inmjzy8kh2sard1hxc6ds8mkbwxx29wzsk15sar1xb70i1xrc";
            };

            nativeBuildInputs = [
              autoPatchelfHook
            ];

            sourceRoot = ".";

            installPhase = ''
              install -m755 -D cockroach-v${version}.linux-amd64/cockroach $out/bin/cockroach
            '';

            meta = with nixpkgs.lib; {
              homepage = "https://cockroach-labs.com";
              description = "CockroachDB binary";
              platforms = platforms.linux;
            };
          };
        });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      defaultPackage = forAllSystems (system: self.packages.${system}.cockroachdb-bin);
    };
}

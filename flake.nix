{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      SYSTEMS = ["x86_64-linux"];

      inherit (nixpkgs.lib) genAttrs substring;

      version = "${substring 0 8 self.lastModifiedDate}-${self.shortRev or "dirty"}";

      forAllSystems = f: genAttrs SYSTEMS (system: f system);

      buildChrysto = { system, isShell ? false }:
        let
          pkgs = import nixpkgs {
            inherit system;
          };

        in pkgs.stdenv.mkDerivation {
          name = "chrysto-${version}";

          buildInputs = [
            pkgs.bs-platform
            pkgs.nodePackages.npm
            pkgs.nodePackages.webpack
            pkgs.nodePackages.vue-cli ];

          src = if isShell then null else self;

          buildPhase = "bsb -make-wolrd && vue-cli-service build";
        };

    in rec {
      defaultPackage = forAllSystems (system: packages."${system}".build);
      devShell = forAllSystems (system: buildChrysto { inherit system; isShell =
        true; });
      packages = forAllSystems (system: {
        build = buildChrysto { inherit system; };
      });
    };
}

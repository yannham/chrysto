{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, nodejs ? pkgs."nodejs-12_x" }:
    let
      SYSTEMS = ["x86_64-linux"];

      inherit (nixpkgs.lib) genAttrs substring;

      version = "${substring 0 8 self.lastModifiedDate}-${self.shortRev or "dirty"}";

      forAllSystems = f: genAttrs SYSTEMS (system: f system);

      nodeEnv = import ./node-env.nix {
        inherit (pkgs) stdenv lib python2 runCommand writeTextFile;
        inherit pkgs nodejs;
        libtool = if pkgs.stdenv.isDarwin then pkgs.darwin.cctools else null;
      };

      buildChrysto = { system, isShell ? false }:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        nodePackages = import ./node-packages.nix {
          inherit (pkgs) fetchurl nix-gitignore stdenv lib fetchgit;
          inherit nodeEnv;
        }

        in pkgs.stdenv.mkDerivation {
          name = "chrysto-${version}";

          buildInputs = [
            pkgs.nodejs
            pkgs.python2
            pkgs.nodePackages.vue-cli ];

          src = if isShell then null else self;

          buildPhase = "bsb -make-world && vue build";
          installPhase = "mkdir -p $out; cp -r ./* $out;";
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

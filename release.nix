{ compiler ? "ghc844" }:

let

  config   = { allowUnfree = true; };
  overlays = [
    (newPkgs: oldPkgs: rec {

      haskell = oldPkgs.haskell // {
        packages = oldPkgs.haskell.packages // {
          "${compiler}" = oldPkgs.haskell.packages."${compiler}".override {
            overrides =
              oldPkgs.haskell.lib.packageSourceOverrides {
                "shared-memory" = newPkgs.haskellPackages.callCabal2nix "shared-memory" ./. { };
              };
          };
        };
      };
    })
  ];

  nixpkgs = import ./nix/18_09.nix;
  pkgs    = import nixpkgs { inherit config overlays; };

in

  { shared-memory = pkgs.haskellPackages.shared-memory; }

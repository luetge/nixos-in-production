{
  description = "nixos in prod";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      # Get packages
      pkgs = import nixpkgs {
        inherit system;
      };

      # Create a shell to build the project with a given rust toolchain
      create-shell = { }:
        pkgs.mkShell ({
          buildInputs = with pkgs;
            [
            ] ++ lib.optional (!stdenv.isDarwin) [
              pkgs.sssd
            ];
        });

    in rec {
      packages = {
      };

      devShells = {
        default = create-shell { };
      };
    });
}

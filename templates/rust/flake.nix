{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    fenix,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        toolchain = fenix.packages.${system}.default.toolchain;
      in {
        devShells.default = with pkgs;
          mkShell {
            buildInputs =
              [
                toolchain
              ]
              ++ [
                pkgs.openssl
                pkgs.pkg-config
                pkgs.cargo-deny
                pkgs.cargo-edit
                pkgs.cargo-watch
                pkgs.rust-analyzer
              ];
          };
        env = {
          RUST_SRC_PATH = "${toolchain}/lib/rustlib/src/rust/library";
        };
      }
    );
}

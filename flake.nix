# SPDX-FileCopyrightText: 2024 The DeckCheatz Developers
#
# SPDX-License-Identifier: Apache-2.0

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    devenv.url = "github:cachix/devenv";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , devenv
    , ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = nixpkgs.outputs.legacyPackages.${system};
        devenvShell = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            ({ inputs, pkgs, ... }: {
              imports = [ ./devenv.nix ];
            })
          ];
        };

      in
      {
        packages.deckcheatz = pkgs.callPackage ./build-aux/nix/deckcheatz.nix { };
        packages.default = self.outputs.packages.${system}.deckcheatz;
        # use flake-parts
        devShells.default = pkgs.buildFHSUserEnv {
          name = "deckcheatz-dev";
          inputsFrom = devenvShell;
          targetPkgs = pkgs: with pkgs; [
            bun
            cabextract
            cairo
            cargo
            cargo-tauri
            clippy
            cmake
            gcc
            git
            glibc
            gtk3
            openssl
            pkg-config
            python3Packages.aiohttp
            python3Packages.pipx
            python3Packages.toml
            rustc
            rustfmt
            rustup
          ] ++ [ self.packages.${system}.deckcheatz ];
        };
      }) // {
      overlays.default = final: prev: {
        inherit (self.packages.${final.system}) deckcheatz;
      };
    };
}

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
    }:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = nixpkgs.outputs.legacyPackages.${system};
      in
      {
        packages.deckcheatz = pkgs.callPackage ./dist/Nix/deckcheatz.nix { };
        packages.default = self.outputs.packages.${system}.deckcheatz;

        devShells.${system}.default = devenv.lib.mkShell {
          inherit pkgs self system;
          imports = [ ./devenv.nix ];
        };
      }) // {
      overlays.default = final: prev: {
        inherit (self.packages.${final.system}) deckcheatz;
      };
    };
}

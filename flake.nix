# SPDX-FileCopyrightText: 2024-2025 The DeckCheatz Developers
#
# SPDX-License-Identifier: Apache-2.0

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    devenv.url = "github:cachix/devenv";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs =
    { self
    , ...
    }@inputs:
    let
      genPkgs =
        system:
        import inputs.nixpkgs {
          inherit system;
        };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      treeFmtEachSystem = f: inputs.nixpkgs.lib.genAttrs systems (system: f inputs.nixpkgs.legacyPackages.${system});
      treeFmtEval = treeFmtEachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./build-aux/nix/formatter.nix);

      forEachSystem = inputs.nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forEachSystem (system:
        let
          pkgs = genPkgs system;
        in
        {
          deckcheatz = pkgs.callPackage ./build-aux/nix { inherit self; };
          default = self.packages.${system}.deckcheatz;
        });

      # for `nix fmt`
      formatter = treeFmtEachSystem (pkgs: treeFmtEval.${pkgs.system}.config.build.wrapper);
      # for `nix flake check`

      checks =
        treeFmtEachSystem
          (pkgs: {
            formatting = treeFmtEval.${pkgs.system}.config.build.wrapper;
          })
        // forEachSystem (system: {
          pre-commit-check = import ./build-aux/nix/checks.nix {
            inherit
              self
              system
              inputs;
            inherit (inputs.nixpkgs) lib;
          };
        });

      # use flake-parts
      devShells = forEachSystem
        (system:
          let
            pkgs = genPkgs system;
          in
          {
            default = pkgs.buildFHSUserEnv
              {
                name = "deckcheatz-dev";
                targetPkgs = pkgs: with pkgs; [
                  bun
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
          }
        );
    } // {
      overlays.default = final: prev: {
        inherit (self.packages.${final.system}) deckcheatz;
      };
    };
}

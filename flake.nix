# SPDX-FileCopyrightText: 2024-2025 The DeckCheatz Developers
#
# SPDX-License-Identifier: Apache-2.0
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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

  outputs = inputs: let
    inherit (inputs) self;
    systems = [
      "x86_64-linux"
    ];
    treeFmtEachSystem = f: inputs.nixpkgs.lib.genAttrs systems (system: f inputs.nixpkgs.legacyPackages.${system});
    treeFmtEval = treeFmtEachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./build-aux/nix/formatter.nix);
    forEachSystem = let
      genPkgs = system: inputs.nixpkgs.legacyPackages.${system};
      inherit (inputs.nixpkgs.lib) genAttrs;
    in
      f: genAttrs systems (system: f (genPkgs system));
  in
    {
      packages = let
        getVersion = toml: (builtins.fromTOML (builtins.readFile toml))."package"."version";
      in
        forEachSystem (pkgs: {
          deckcheatz = let
            version = getVersion ./Cargo.toml;
          in
            pkgs.callPackage ./build-aux/nix {inherit self version;};
          default = self.packages.${pkgs.stdenv.hostPlatform.system}.deckcheatz;
        });

      # for `nix fmt`
      formatter = treeFmtEachSystem (pkgs: treeFmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper);

      # for `nix flake check`
      checks =
        treeFmtEachSystem
        (pkgs: {
          formatting = treeFmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper;
        })
        // forEachSystem (pkgs: {
          pre-commit-check = import ./build-aux/nix/checks.nix {
            inherit
              self
              inputs
              ;
            inherit (pkgs) lib system;
          };
        });

      # use flake-parts
      devShells =
        forEachSystem
        (
          pkgs: {
            default =
              pkgs.buildFHSEnv
              {
                name = "deckcheatz-dev";
                targetPkgs = pkgs:
                  with pkgs;
                    [
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
                    ]
                    ++ [self.packages.${pkgs.stdenv.hostPlatform.system}.deckcheatz];
              };
          }
        );
    }
    // {
      overlays.default = final: _: {
        inherit (self.packages.${final.system}) deckcheatz;
      };
    };
}

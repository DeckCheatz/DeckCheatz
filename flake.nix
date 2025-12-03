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
    treeFmtEval = forEachSystem (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./build-aux/nix/formatter.nix);
    forEachSystem = let
      genPkgs = system: inputs.nixpkgs.legacyPackages.${system};
      inherit (inputs.nixpkgs.lib) genAttrs;
    in
      f: genAttrs systems (system: f (genPkgs system));
  in
    {
      packages = forEachSystem (pkgs: {
        deckcheatz = pkgs.callPackage ./build-aux/nix/deckcheatz.nix {inherit self;};
        deckcheatz-shim = pkgs.callPackage ./build-aux/nix/deckcheatz-shim.nix {inherit self;};
        default = self.packages.${pkgs.stdenv.hostPlatform.system}.deckcheatz;
      });

      # for `nix fmt`
      formatter = forEachSystem (pkgs: treeFmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper);

      # for `nix flake check`
      checks = forEachSystem (pkgs: {
        pre-commit-check = import ./build-aux/nix/checks.nix {
          inherit
            self
            inputs
            ;
          inherit (pkgs) lib system;
        };
        formatting = treeFmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper;
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
                      git
                      python3
                    ]
                    ++ (with self.packages.${pkgs.stdenv.hostPlatform.system}; [
                      deckcheatz
                    ]);
              };
          }
        );
    }
    // {
      overlays.default = final: _: {
        inherit (self.packages.${final.stdenv.hostPlatform.system}) deckcheatz;
      };
    };
}

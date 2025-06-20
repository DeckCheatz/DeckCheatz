# SPDX-FileCopyrightText: 2024-2025 The DeckCheatz Developers
#
# SPDX-License-Identifier: Apache-2.0

{ system
, inputs
, lib
, ...
}:
inputs.git-hooks.lib.${system}.run {
  src = lib.cleanSource ./.;
  hooks = {
    deadnix.enable = true;
    statix.enable = true;
    statix.settings.ignore = [ "flake.nix" "builddir" ".flatpak-builder" ];
    nixpkgs-fmt.enable = true;
    prettier.enable = true;
    yamlfmt.enable = true;
    actionlint.enable = true;
    rustfmt.enable = true;
  };
}

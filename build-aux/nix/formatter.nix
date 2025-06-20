# SPDX-FileCopyrightText: 2024-2025 The DeckCheatz Developers
#
# SPDX-License-Identifier: Apache-2.0

{ pkgs, ... }:
{
  package = pkgs.treefmt;
  projectRootFile = "flake.nix";

  settings = {
    global.excludes = [
      "*.age"
      "*.md"
      "*.gpg"
      "*.bin"
    ];
    shellcheck.includes = [
      "*"
      ".envrc"
    ];
  };
  programs = {
    deadnix.enable = true;
    statix.enable = true;
    alejandra.enable = true;
    prettier.enable = true;
    yamlfmt.enable = true;
    jsonfmt.enable = true;
    mdformat.enable = true;
    actionlint.enable = true;
  };
}

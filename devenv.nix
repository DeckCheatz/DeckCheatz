# SPDX-FileCopyrightText: 2024 The DeckCheatz Developers
#
# SPDX-License-Identifier: Apache-2.0

{ pkgs, ... }:

{
  packages = with pkgs; [
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
  ];

  languages = {
    nix.enable = true;
    typescript.enable = true;
    javascript.enable = true;
    javascript.npm.enable = true;
    rust.enable = true;
    shell.enable = true;
  };

  devcontainer.enable = true;
  difftastic.enable = true;

  pre-commit.hooks = {
    rustfmt = {
      enable = true;
    };
    clippy = {
      enable = true;
      settings = {
        offline = false;
      };
    };
    shellcheck.enable = true;
    shfmt.enable = true;
    actionlint.enable = true;
    nixpkgs-fmt.enable = true;
    markdownlint.enable = true;
    statix.enable = true;
  };
}

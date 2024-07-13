# SPDX-FileCopyrightText: 2024 The DeckCheatz Developers
#
# SPDX-License-Identifier: Apache-2.0

{ pkgs, ... }:

{
  packages = with pkgs; [
    git

    python3Packages.aiohttp
    python3Packages.pipx
    python3Packages.toml

    pkg-config
    cargo
    rustc
    cargo-tauri
    nodejs-slim
    openssl
    bun
    openssl
    glibc
    libsoup_3
    libsoup
    cairo
    gtk3
    webkitgtk
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

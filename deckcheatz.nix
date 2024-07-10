# SPDX-FileCopyrightText: 2024 The DeckCheatz Developers
#
# SPDX-License-Identifier: Apache-2.0

{ lib
, pkgs ? import <nixpkgs>
, rustPlatform
,
}:
rustPlatform.buildRustPackage {
  name = "deckcheatz";

  src = lib.cleanSource ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
    # Allow dependencies to be fetched from git and avoid having to set the outputHashes manually
    allowBuiltinFetchGit = true;
  };

  nativeBuildInputs = with pkgs; [ pkg-config cmake openssl.dev ];
  buildInputs = with pkgs; [ openssl.dev ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/DeckCheatz/DeckCheatz";
    license = licenses.asl20;
  };
}

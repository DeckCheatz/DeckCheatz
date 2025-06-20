# SPDX-FileCopyrightText: 2024-2025 The DeckCheatz Developers
#
# SPDX-License-Identifier: Apache-2.0
{
  lib,
  rustPlatform,
  pkg-config,
  expat,
  openssl,
  fontconfig,
  freetype,
  libGL,
  libxkbcommon,
  pipewire,
  wayland,
  xorg,
  self,
}: let
  pname = "deckcheatz";
  version = "unstable";

  src = lib.cleanSource self;
in
  rustPlatform.buildRustPackage {
    inherit version src pname;

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };

    dontFixup = true;

    outputs = [
      "out"
      "steamcompattool"
    ];

    installPhase = ''
      runHook preInstall

      # Make it impossible to add to an environment. You should use the appropriate NixOS option.
      # Also leave some breadcrumbs in the file.
      echo "${pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

      install -Dt $steamcompattool build-aux/steam/compatibilitytool.vdf build-aux/steam/toolmanifest.vdf
      install -Dt $steamcompattool -m755 target/*/release/deckcheatz

      runHook postInstall
    '';

    nativeBuildInputs = [pkg-config];
    OPENSSL_NO_VENDOR = 1;
    PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";

    buildInputs = [
      expat
      fontconfig
      freetype
      libGL
      libxkbcommon
      openssl.dev
      pipewire
      rustPlatform.bindgenHook
      wayland
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
    ];

    postFixup = ''
      patchelf $out/bin/deckcheatz \
        --add-rpath ${lib.makeLibraryPath [libGL libxkbcommon wayland]}
    '';

    meta = with lib; {
      description = "";
      homepage = "https://deckcheatz.github.io";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [shymega];
      mainProgram = "deckcheatz";
    };
  }

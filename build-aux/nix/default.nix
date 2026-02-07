# SPDX-FileCopyrightText: 2024-2025 The DeckCheatz Developers
#
# SPDX-License-Identifier: Apache-2.0
{
  expat,
  fontconfig,
  freetype,
  lib,
  libGL,
  libX11,
  libXcursor,
  libXi,
  libXrandr,
  libxkbcommon,
  openssl,
  pipewire,
  pkg-config,
  rustPlatform,
  self,
  wayland,
  version,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  name = "deckcheatz";
  inherit version;

  src = lib.cleanSource self;

  cargoLock = {
    lockFile = "${finalAttrs.src}/Cargo.lock";
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
    install -Dt $out/usr/bin -m755 target/*/release/deckcheatz

    install -Dt $steamcompattool build-aux/steam/compatibilitytool.vdf build-aux/steam/toolmanifest.vdf
    # install -Dt $steamcompattool -m755 target/*/release/deckcheatz-shim

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
    libX11
    libXcursor
    libXi
    libXrandr
  ];

  postFixup = ''
    patchelf $out/usr/bin/deckcheatz \
      --add-rpath ${lib.makeLibraryPath [libGL libxkbcommon wayland]}
  '';

  meta = {
    description = "";
    homepage = "https://deckcheatz.github.io";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [shymega];
    mainProgram = "deckcheatz";
  };
})

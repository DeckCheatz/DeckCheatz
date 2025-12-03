# SPDX-FileCopyrightText: 2024-2025 The DeckCheatz Developers
#
# SPDX-License-Identifier: Apache-2.0
{
  lib,
  pkg-config,
  python3Packages,
  self,
}: let
  pname = "deckcheatz-shim";
  version = "unstable";

  src = lib.cleanSource "${self}/packages/deckcheatz-shim";
in
  python3Packages.buildPythonApplication rec {
    inherit version src pname;
    pyproject = true;

    build-system = with python3Packages; [setuptools];

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

      install -Dt $steamcompattool ${self}/build-aux/steam/compatibilitytool.vdf ${self}/build-aux/steam/toolmanifest.vdf

      runHook postInstall
    '';

    meta = with lib; {
      description = "";
      homepage = "https://deckcheatz.github.io";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [shymega];
      mainProgram = "deckcheatz";
    };
  }

# SPDX-FileCopyrightText: 2024-2025 The DeckCheatz Developers
#
# SPDX-License-Identifier: Apache-2.0
{
  lib,
  pkg-config,
  python3Packages,
  self,
}: let
  pname = "deckcheatz";
  version = "unstable";

  src = lib.cleanSource "${self}/packages/deckcheatz";
in
  python3Packages.buildPythonApplication rec {
    inherit version src pname;
    pyproject = true;

    build-system = with python3Packages; [setuptools];

    meta = with lib; {
      description = "";
      homepage = "https://deckcheatz.github.io";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [shymega];
      mainProgram = "deckcheatz";
    };
  }

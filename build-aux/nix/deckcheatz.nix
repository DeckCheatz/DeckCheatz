{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, expat
, fontconfig
, freetype
, libGL
, libxkbcommon
, pipewire
, wayland
, xorg
}:
let
  pname = "deckcheatz";
  version = "unstable";

  src = lib.cleanSource ../../.;
in
rustPlatform.buildRustPackage {
  inherit version src pname;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    expat
    fontconfig
    freetype
    libGL
    libxkbcommon
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
      --add-rpath ${lib.makeLibraryPath [ libGL libxkbcommon wayland ]}
  '';

  meta = with lib; {
    description = "";
    homepage = "https://deckcheatz.github.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ shymega ];
    mainProgram = "deckcheatz";
  };
}

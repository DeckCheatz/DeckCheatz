{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, expat
, openssl
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

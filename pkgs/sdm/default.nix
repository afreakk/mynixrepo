{ unzip ? (import <nixpkgs> {}).pkgs.unzip,
  stdenv ? (import <nixpkgs> {}).stdenv,
  autoPatchelfHook?(import <nixpkgs> {}).autoPatchelfHook
}:
stdenv.mkDerivation {
  name = "strongdm";
  src = stdenv.mkDerivation {
    src = ./sdmcli_1.5.13_linux_amd64.zip;
    name = "strongdmpre";
    buildInputs = [ unzip ];
    unpackPhase = ''
      unzip $src
    '';
    installPhase = ''
      install -D sdm $out/bin/sdm
    '';
    nativeBuildInputs = [ autoPatchelfHook ];
  };
  installPhase = ''
    bin/sdm install || true
    install -D bin/sdm $out/bin/sdm
    install -D state.db $out/state.db
  '';
}


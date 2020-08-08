{stdenv, ghc}:
stdenv.mkDerivation  {
  name = "dmenuhistory";
  version = "1.0.0";
  src = ./dmenuhistory/dmenuhist.hs;
  buildInputs = [ ghc ];
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    ghc -O2 -o $out/bin/dmenuhist $src
  '';
}

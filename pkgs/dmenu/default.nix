{ stdenv, libX11, libXinerama, zlib, libXft }:
stdenv.mkDerivation {
   buildInputs = [ libX11 libXinerama zlib libXft ];
   src = ./dmenu/.;
   name = "dmenu-afreak";
   preConfigure = ''
      sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk
   '';
}

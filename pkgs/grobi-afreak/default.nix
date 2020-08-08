{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage {
  version = "0.6.0";
  pname = "grobi";

  goPackagePath = "github.com/fd0/grobi";

  src = fetchFromGitHub {
    rev = version;
    owner = "fd0";
    repo = "grobi";
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

   meta = with stdenv.lib; {
    homepage = "https://github.com/fd0/grobi";
    description = "Automatically configure monitors/outputs for Xorg via RANDR";
    license = with licenses; [ bsd2 ];
    platforms   = platforms.linux;
  };
}

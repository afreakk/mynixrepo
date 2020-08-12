{ jq, expect, stdenv, fetchFromGitHub, _1password, gnused}:
stdenv.mkDerivation rec {
  buildInputs = [ jq expect ];
  pname = "dcreemer-1pass";
  version = "1.2";
  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "dcreemer";
    repo = "1pass";
    sha256 = "0lchx4rcs8sb17jxfm7mqwlsfq3ip87am2wl7sb04g9c6r2gsg3p";
  };
  postPatch = ''
    ${gnused}/bin/sed -i "s@\bexpect\b@${expect}/bin/expect@g" 1pass
    ${gnused}/bin/sed -i "s@\bjq\b@${jq}/bin/jq@g" 1pass
    ${gnused}/bin/sed -i "s@\bop\b@${_1password}/bin/op@g" 1pass
    # quite hard to replace all the gpg stuff in the script. so skip that and install it globally
    # ${gnused}/bin/sed -i "s@\bgpg\b@$ {gnupg}/bin/gpg@g" 1pass
    # substituteInPlace 1pass --replace 'expect' '${expect}/bin/expect'
    # substituteInPlace 1pass --replace 'jq' '${jq}/bin/jq'
    # substituteInPlace 1pass --replace 'op' '${_1password}/bin/op'
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp 1pass $out/bin
  '';
}

{ pkgs ? import <nixpkgs> {} }:                                                   
                                                                                   
let
  #START tmux spam (will remove it once https://github.com/NixOS/nixpkgs/pull/95244 is merged
  rtpPath = "share/tmux-plugins";

  addRtp = path: rtpFilePath: attrs: derivation:
    derivation // { rtp = "${derivation}/${path}/${rtpFilePath}"; } // {
      overrideAttrs = f: mkDerivation (attrs // f attrs);
    };

  mkDerivation = a@{
    pluginName,
    rtpFilePath ? (builtins.replaceStrings ["-"] ["_"] pluginName) + ".tmux",
    namePrefix ? "tmuxplugin-",
    src,
    unpackPhase ? "",
    configurePhase ? ":",
    buildPhase ? ":",
    addonInfo ? null,
    preInstall ? "",
    postInstall ? "",
    path ? pkgs.lib.getName pluginName,
    dependencies ? [],
    ...
  }:
    addRtp "${rtpPath}/${path}" rtpFilePath a (pkgs.stdenv.mkDerivation (a // {
      pname = namePrefix + pluginName;

      inherit pluginName unpackPhase configurePhase buildPhase addonInfo preInstall postInstall;

      installPhase = ''
        runHook preInstall
        target=$out/${rtpPath}/${path}
        mkdir -p $out/${rtpPath}
        cp -r . $target
        if [ -n "$addonInfo" ]; then
          echo "$addonInfo" > $target/addon-info.json
        fi
        runHook postInstall
      '';

      dependencies = [ pkgs.bash ] ++ dependencies;
    }));
  #END tmux spam
   self = {
      strongdm = pkgs.callPackage ./pkgs/sdm {};
      dmenu-afreak = pkgs.callPackage ./pkgs/dmenu {};
      dmenuhist = pkgs.callPackage ./pkgs/dmenuhist {};
      grobi-afreak = pkgs.callPackage ./pkgs/grobi-afreak {};
      sidequest = pkgs.callPackage ./pkgs/sidequest {};
      nix-doc = pkgs.callPackage ./pkgs/nix-doc {};
      tmux-fingers = mkDerivation rec {
        pluginName = "fingers";
        rtpFilePath = "tmux-fingers.tmux";
        version = "1.0.1";
        src = pkgs.fetchFromGitHub {
          owner = "Morantron";
          repo = "tmux-fingers";
          rev = version;
          sha256 = "0gp37m3d0irrsih96qv2yalvr1wmf1n64589d4qzyzq16lzyjcr0";
          fetchSubmodules = true;
        };
        dependencies = [ pkgs.gawk ];
      };
      modules = {
         strongdm = import ./modules/sdm;
      };
   };                                                                                   
   in self 


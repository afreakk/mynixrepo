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
      dcreemer-1pass = pkgs.callPackage ./pkgs/dcreemer-1pass {};
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
      tmux-extrakto = mkDerivation rec {
        pluginName = "extrakto";
        version = "0b7d04c3b8118514e853b913bed68e9947d653cd";
        src = pkgs.fetchFromGitHub {
          owner = "laktak";
          repo = "extrakto";
          rev = version;
          sha256 = "11ml0ck5fxnyls83xi7gixgpnpmpp2md2dif6ig8vian9b3v6wjq";
        };
        dependencies = [ pkgs.fzf ];
      };
      # trying to make tmux-thumbs work, but it does not atm, so dont use
      thumbs = pkgs.rustPlatform.buildRustPackage rec {
        pname = "thumbs";
        version = "b0a76015f5b6ab02ab11ffe96271a5ce847e366e";

        src = pkgs.fetchFromGitHub {
          owner = "fcsonline";
          repo = "tmux-thumbs";
          rev = version;
          sha256 = "0fs7plashpqszmbk8d1xpinp5pa0fr39lkn8320ikwlqi0y1r9n2";
        };

        cargoSha256 = "02lqxp56zhwk18f476iid0jcqgs2q4a10gv2ndpm3lqkzqkq7hsm";
      };
      tmux-thumbs = mkDerivation rec {
        pluginName = "thumbs";
        rtpFilePath = "tmux-thumbs.tmux";
        version = "b0a76015f5b6ab02ab11ffe96271a5ce847e366e";
        src = pkgs.fetchFromGitHub {
          owner = "fcsonline";
          repo = "tmux-thumbs";
          rev = version;
          sha256 = "0fs7plashpqszmbk8d1xpinp5pa0fr39lkn8320ikwlqi0y1r9n2";
        };
        buildPhase = ''
          ${pkgs.gnused}/bin/sed -i '$ d' tmux-thumbs.tmux
          ${pkgs.gnused}/bin/sed -i '$ d' tmux-thumbs.tmux
          ${pkgs.gnused}/bin/sed -i '$ d' tmux-thumbs.tmux
          ${pkgs.gnused}/bin/sed -i '$ d' tmux-thumbs.tmux

          ${pkgs.gnused}/bin/sed -i '$ d' tmux-thumbs.sh
          ${pkgs.gnused}/bin/sed -i '$ d' tmux-thumbs.sh
          echo '"${self.thumbs}/bin/tmux-thumbs" "${"\${PARAMS[@]}"}"' >> tmux-thumbs.sh
        '';
        dependencies = [ self.thumbs ];
      };
      modules = {
         strongdm = import ./modules/sdm;
      };
   };                                                                                   
   in self 


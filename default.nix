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
      sidequest = pkgs.callPackage ./pkgs/sidequest {};
      awscli = pkgs.callPackage ./pkgs/awscli {};
      dcreemer-1pass = pkgs.callPackage ./pkgs/dcreemer-1pass {};
      nix-doc = pkgs.callPackage ./pkgs/nix-doc {};
      tmux-jump = mkDerivation rec {
        pluginName = "tmux-jump";
        version = "416f613d3eaadbe1f6f9eda77c49430527ebaffb";
        rtpFilePath = "tmux-jump.tmux";
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postInstall = ''
          ppath=$out/share/tmux-plugins/tmux-jump
          mv $ppath/scripts/tmux-jump.sh $ppath/scripts/tmux-jump-unwrapped.sh
          makeWrapper $ppath/scripts/tmux-jump-unwrapped.sh $ppath/scripts/tmux-jump.sh \
            --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.ruby ]}

        '';
        src = pkgs.fetchFromGitHub {
          owner = "schasse";
          repo = pluginName;
          rev = version;
          sha256 = "1xbzdyhsgaq2in0f8f491gwjmx6cxpkf2c35d2dk0kg4jfs505sz";
        };
        dependencies = [ pkgs.ruby ];
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
      tmux-fzf-url = mkDerivation rec {
        pluginName = "tmux-fzf-url";
        version = "74d4f13c98cec03e4243adf719275ad880dabde0";
        rtpFilePath = "fzf-url.tmux";
        src = pkgs.fetchFromGitHub {
          owner = "wfxr";
          repo = pluginName;
          rev = version;
          sha256 = "0l43pi31isipd9p1qhj5cmajy70l6ijhzi1jpdmhid7735xnx36q";
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
      url-handler-tmux = mkDerivation rec {
        pluginName = "url-handler-tmux";
        version = "cc3d0c4856e548a38c12165318ac82cbb7e1a222";
        # src = ~/coding/url-handler-tmux;
        src = pkgs.fetchFromGitLab {
          owner = "afreakk";
          repo = pluginName;
          rev = version;
          sha256 = "0xas40bzry94akdny2hmmcs130849z4318wvrs1zmyprds6ybhrq";
        };
      };
      modules = {
         strongdm = import ./modules/sdm;
         mcfly_with_fix = import ./modules/mcfly;
      };
   };                                                                                   
   in self 


{ pkgs, ... }:
let
  tmuxHlp = import ./tmuxhelpers.nix { inherit pkgs; };
  self = {
    irc-link-informant = pkgs.callPackage ./pkgs/irc-link-informant { };
    realm-cli = pkgs.callPackage ./pkgs/realm-cli { };
    fish-history-merger = pkgs.callPackage ./pkgs/fish-history-merger { };
    qutebrowser-start-page = pkgs.callPackage ./pkgs/qutebrowser-start-page { };
    wowup = pkgs.callPackage ./pkgs/wowup { };
    strongdm = pkgs.callPackage ./pkgs/sdm { };
    dmenu-afreak = pkgs.callPackage ./pkgs/dmenu { };
    dmenuhist = pkgs.callPackage ./pkgs/dmenuhist { };
    dcreemer-1pass = pkgs.callPackage ./pkgs/dcreemer-1pass { };
    mongosh = pkgs.callPackage ./pkgs/mongosh { };
    url-handler-tmux = tmuxHlp.mkDerivation rec {
      pluginName = "url-handler-tmux";
      version = "2366e0a8e3728dc2f08137b6fc89c56ef36506ed";
      src = pkgs.fetchFromGitHub {
        owner = "afreakk";
        repo = pluginName;
        rev = version;
        sha256 = "sha256-hrbmw/HBf0MlQGl5riRqK66BJLEVXM4zR43FhY1gOTg=";
      };
    };
    modules = {
      strongdm = import ./modules/sdm;
      systemd-cron = import ./modules/systemd-cron;
      scheduled-rsync = import ./modules/scheduled-rsync;
      joystickwake = import ./modules/joystickwake;
      xscreensaver-fork = import ./modules/xscreensaver;
    };
    system-modules = {
      irc-link-informant = import ./modules/irc-link-informant;
    };
  };
in
self

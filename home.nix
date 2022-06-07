{ config, pkgs, ... }:

let
  recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };

  foosNixpkgs = "/home/gui/foos/nixpkgs/pkgs/";

  callPackage2 = path: obj: pkgs.callPackage (foosNixpkgs + path) obj;
  
  sublime4 = 
    let
      sublime4Packages = recurseIntoAttrs (callPackage2 "/applications/editors/sublime/4/packages.nix" { });
    in
      sublime4Packages.sublime4-dev;
in {

  home.packages = with pkgs; [
    ammonite
    awscli
    calibre
    coursier
    dmenu
    docker-compose
    flyway
    gimp
    gnome3.gnome-screenshot
    gnupg
    graalvm11-ce
    graphviz
    inotify-tools
    jd-gui
    kdiff3
    killall
    kubectl
    kubectx
    lastpass-cli
    libxml2
    loc
    mplayer
    nodejs-16_x
    ngrok
    pavucontrol
    pgcli
    sbt
    simplescreenrecorder
    sublime4
    terraform
    tig
    tree
    unzip
    vscode
    wget
    wrangler
    xclip
    xvkbd
    yarn
    youtube-dl
    yq
  ];

  programs = {
    jq.enable = true;
    htop.enable = true;
    go.enable = true;
    chromium = {
      enable = true;
      extensions = [
        "kbfnbcaeplbcioakkpcpgfkobkghlhen" # Grammarly for Chrome
        "hdokiejnpimakedhajhdlcegeplioahd" # LastPass
        "fmkadmapgofadopljbjfkapdkoienihi" # React Developer Tools
        "lmhkpmbekcpmknklioeibfkpmmfibljd" # Redux DevTools
        "clngdbkpkpeebahjckkjfobafhncgmne" # Stylus
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      ];
    };

    git = {
      enable = true;
      userEmail = "masse.guillaume@narrative.io";
      userName = "Guillaume Massé";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs : rec {
      yarn = pkgs.yarn.override { 
        nodejs = pkgs.nodejs-12_x;
      };

      # vscode = callPackage2 "applications/editors/vscode/vscodium.nix" { };

      sbt = callPackage2 "development/tools/build-managers/sbt" {
        jre = pkgs.graalvm11-ce;
      };
    };
  };
}

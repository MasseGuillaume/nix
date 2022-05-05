{ config, pkgs, ... }:

let
  screenshot = pkgs.writeShellScript "screenshot.sh" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
  '';
  recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };

  foosNixpkgs = "/home/gui/foos/nixpkgs/pkgs/";

  callPackage2 = path: obj: pkgs.callPackage (foosNixpkgs + path) obj;
  
  sublime4 = 
    let
      sublime4Packages = recurseIntoAttrs (callPackage2 "/applications/editors/sublime/4/packages.nix" { });
    in
      sublime4Packages.sublime4-dev;
in
{
  home.packages = with pkgs; [
    ammonite
    gnome3.gnome-screenshot
    inotify-tools
    killall
    kubectl
    libxml2
    loc
    mplayer
    ngrok
    nodejs-14_x
    nodePackages.typescript
    openjdk
    pavucontrol
    postgresql
    sbt
    sublime4
    tig
    wget
    yarn

    # narrative
    docker-compose
    flyway
    terraform
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
      sbt = callPackage2 "development/tools/build-managers/sbt" {
        jre = pkgs.graalvm11-ce;
      };
    };
  };
}

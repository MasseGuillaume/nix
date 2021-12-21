{ config, pkgs, lib, ... }:

let
  screenshot = pkgs.writeShellScript "screenshot.sh" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
  '';
  sublime4 = 
    let
      recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };
      sublime4Packages = recurseIntoAttrs (pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/applications/editors/sublime/4/packages.nix { });
    in
      sublime4Packages.sublime4-dev;
in
{
  home.packages = with pkgs; [
    ammonite
    bs-platform
    gnome3.gnome-screenshot
    google-cloud-sdk
    # home-manager
    inotify-tools
    killall
    kubectl
    libxml2
    loc
    mplayer
    ngrok
    nodejs-12_x
    nodePackages.typescript
    openjdk
    pavucontrol
    postgresql
    pulumi
    sbt
    telepresence
    tig
    vscode
    sublime4
    wget
    yarn
    zoom-us
  ];

  programs = {
    vscode.enable = true;
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
      userEmail = "masgui@gmail.com";
      userName = "Guillaume Massé";

      # extraConfig = {}
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs : rec {
      pulumi = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/tools/admin/pulumi/default.nix { };
      postgresql = pkgs.postgresql_12;
      yarn = pkgs.yarn.override { 
        nodejs = pkgs.nodejs-12_x;
      };
      telepresence = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/tools/networking/telepresence {
        pythonPackages = pkgs.python3Packages;
      };      
      sbt = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/development/tools/build-managers/sbt/default.nix {
        jre = pkgs.graalvm11-ce; 
      };

      vscode = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/applications/editors/vscode/vscode.nix { };
      zoom-us = (pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/applications/networking/instant-messengers/zoom-us {
        util-linux = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/os-specific/linux/util-linux {};
        alsa-lib = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/os-specific/linux/alsa-project/alsa-lib { };
      }).overrideAttrs (old: {
      postFixup = old.postFixup + ''
        wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE
      '';});
    };
  };
}

{ config, pkgs, ... }:

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
    # bs-platform
    # clojure
    # glib
    # google-cloud-sdk
    # gopls
    # grpcurl
    # home-manager
    # leiningen
    # pulumi
    # telepresence
    # vscode
    # wine
    # zoom-us
    altair
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
  ];

  programs = {
    # vscode.enable = true;
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

      # extraConfig = {}
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs : rec {
      callPackage2 = path: obj:
        pkgs.callPackage ("/home/gui/foos/nixpkgs/pkgs/" + path) obj;

      yarn = pkgs.yarn.override { 
        nodejs = pkgs.nodejs-12_x;
      };
      sbt = callPackage2 "development/tools/build-managers/sbt" {
        # jre = graalvm17-ce;
        jre = pkgs.graalvm11-ce;
      };

      # pulumi = callPackage2 "tools/admin/pulumi" { };

      # postgresql = pkgs.postgresql_12;
      # telepresence = callPackage2 "tools/networking/telepresence" {
      #   pythonPackages = pkgs.python3Packages;
      # };
      # graalvmCEPackages = pkgs.recurseIntoAttrs (
      #   callPackage2 development/compilers/graalvm/community-edition {}
      # );
      # graalvm17-ce = graalvmCEPackages.graalvm17-ce;
      # clojure = pkgs.clojure.override {
      #   # jdk = graalvm17-ce;
      #   jdk = pkgs.graalvm11-ce;
      # };
      # leiningen = pkgs.leiningen.override {
      #   # jdk = graalvm17-ce;
      #   jdk = pkgs.graalvm11-ce;
      # };
      # vscode = callPackage2 "applications/editors/vscode/vscode.nix" { };
      # zoom-us = 
      #   (callPackage2 "applications/networking/instant-messengers/zoom-us" {
      #       # util-linux = callPackage2 "os-specific/linux/util-linux" {};
      #       # alsa-lib = callPackage2 "os-specific/linux/alsa-project/alsa-lib" { };
      #     }).overrideAttrs (old: {
      #     postFixup = old.postFixup + ''
      #       wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE
      #     '';
      #   });
    };
  };
}

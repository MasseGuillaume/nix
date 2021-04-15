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
    wl-clipboard
  ];

  programs = {
    vscode.enable = true;
    jq.enable = true;
    htop.enable = true;

    alacritty = {
      enable = true;
    };

    password-store = {
      enable = true;
      package = pkgs.pass-wayland;
    };

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

  wayland.windowManager = rec {
    sway = {
      enable = true;
      systemdIntegration = false;
      config =
        let
          mod = "Mod1";
          leftOutput = "DVI-D-1";
          centerOutput = "HDMI-A-1";
          rightOutput = "DP-1";
        in {
          focus.mouseWarping = false;
          window.border = 0;
          modifier = "Mod1";
          bars = [];
          modes = {};
          keybindings = {
            "${mod}+Return"        = "exec alacritty";
            "${mod}+Shift+Return"  = "exec alacritty";
            "${mod}+k"             = "kill";
            "${mod}+d"             = "exec dmenu_run";
            "${mod}+f"             = "fullscreen toggle";
            "${mod}+Shift+q"       = "exec swaynag -t warning -m 'Kill Saw?' -b 'Yes' 'swaymsg exit'";
            "${mod}+F1"            = "exec ${screenshot}";
            "${mod}+space"         = "floating toggle";


            "${mod}+h" = "focus left";
            "${mod}+s" = "focus right";
            "${mod}+n" = "focus down";
            "${mod}+t" = "focus up";
            
            "${mod}+Shift+h" = "move left";
            "${mod}+Shift+s" = "move right";
            "${mod}+Shift+n" = "move down";
            "${mod}+Shift+t" = "move up";

            "${mod}+Shift+g" = "resize shrink width 25 px";
            "${mod}+Shift+c" = "resize grow height 25 px";
            "${mod}+Shift+r" = "resize shrink height 25 px";
            "${mod}+Shift+l" = "resize grow width 25 px";

            "${mod}+o" = "focus output ${leftOutput}";
            "${mod}+e" = "focus output ${centerOutput}";
            "${mod}+u" = "focus output ${rightOutput}";

            "${mod}+Shift+o" = "move container to output ${leftOutput}";
            "${mod}+Shift+e" = "move container to output ${centerOutput}";
            "${mod}+Shift+u" = "move container to output ${rightOutput}";
            
            "${mod}+1" = "workspace number 1";
            "${mod}+2" = "workspace number 2";
            "${mod}+3" = "workspace number 3";
            "${mod}+4" = "workspace number 4";
            "${mod}+5" = "workspace number 5";
            "${mod}+6" = "workspace number 6";
            "${mod}+7" = "workspace number 7";
            "${mod}+8" = "workspace number 8";
            "${mod}+9" = "workspace number 9";
            
            "${mod}+Shift+1" = "move container to workspace number 1";
            "${mod}+Shift+2" = "move container to workspace number 2";
            "${mod}+Shift+3" = "move container to workspace number 3";
            "${mod}+Shift+4" = "move container to workspace number 4";
            "${mod}+Shift+5" = "move container to workspace number 5";
            "${mod}+Shift+6" = "move container to workspace number 6";
            "${mod}+Shift+7" = "move container to workspace number 7";
            "${mod}+Shift+8" = "move container to workspace number 8";
            "${mod}+Shift+9" = "move container to workspace number 9";
          };

          output = {
            "*" = {
              transform = "90";
              background = "#000000 solid_color";
            };
            "${leftOutput}"   = { pos = "0 0";    };
            "${centerOutput}" = { pos = "1080 0"; };
            "${rightOutput}"  = { pos = "2160 0"; };
          };
          input = {
            "type:keyboard" = {
              repeat_delay = "200";
              repeat_rate = "50";
            };
          };
        };
    };
  };

  news.display = "silent";

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs : rec {
      pulumi = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/tools/admin/pulumi/default.nix { };
      vscode = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/applications/editors/vscode/vscode.nix { };
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
    };
  };
}

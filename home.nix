{ config, pkgs, lib, ... }:

let
  screenshot = pkgs.writeShellScript "screenshot.sh" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
  '';
in
{
  # environment = {
  #   variables = {
  #     SBT_OPTS="-Xms512M -Xmx2G -Xss1M -XX:+CMSClassUnloadingEnabled";
  #   };
  # };

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
    sublime3
    telepresence
    tig
    vscode
    wget
    xclip
    yarn
    zoom-us
    wl-clipboard
  ];

  programs = {
    vscode.enable = true;
    jq.enable = true;
    htop.enable = true;

    kitty = {
      enable = true;
      settings.term = "xterm-256color";
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
      config = {       
        focus.mouseWarping = false;
        window.border = 0;
        modifier = "Mod1";
        bars = [];
        keybindings =
          let
            mod = "Mod1";
          in
            {
              "${mod}+Return" = "exec kitty";
              "${mod}+Shift+q" = "kill";
              "${mod}+d" = "exec dmenu_run";

              "${mod}+h" = "focus left";
              "${mod}+Shift+h" = "move left";
              "${mod}+s" = "focus right";
              "${mod}+Shift+s" = "move right";


              "${mod}+n" = "focus down";
              "${mod}+Shift+n" = "move down";
              "${mod}+t" = "focus up";
              "${mod}+Shift+t" = "move up";

              
              "${mod}+b" = "splith";
              "${mod}+v" = "splitv";
              "${mod}+f" = "fullscreen toggle";
              "${mod}+a" = "focus parent";

              # "${mod}+s" = "layout stacking";
              "${mod}+w" = "layout tabbed";
              "${mod}+e" = "layout toggle split";

              "${mod}+Shift+space" = "floating toggle";
              "${mod}+space" = "focus mode_toggle";

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

              "${mod}+Shift+minus" = "move scratchpad";
              "${mod}+minus" = "scratchpad show";

              "${mod}+Shift+c" = "reload";
              "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

              "${mod}+r" = "mode resize";

              "${mod}+Shift+g" = "exec ${screenshot}";
            };

        # DVI-D-0 | HDMI-A-0 | DisplayPort-0
        output = {
          "*" = {
            transform = "90";
            background = "#000000 solid_color";
          };
          "DVI-D-1" = {
            pos = "0 0";
            
          };
          "HDMI-A-1" = {
            pos = "1080 0";
          };
          "DP-1" = {
            pos = "2160 0";
          };
        };
        input = {
          "type:keyboard" = {
            repeat_delay = "150";
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
      # chromedriver = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/development/tools/selenium/chromedriver {
      #   gconf = pkgs.gnome2.GConf;
      # }; 
      pulumi = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/tools/admin/pulumi/default.nix { };
      vscode = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/applications/editors/vscode/vscode.nix { };
      postgresql = pkgs.postgresql_12;
      yarn = pkgs.yarn.override { 
        nodejs = pkgs.nodejs-12_x;
      };
      telepresence = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/tools/networking/telepresence {
        pythonPackages = pkgs.python3Packages;
      };
      sbt = pkgs.sbt.override {
        jre = pkgs.graalvm11-ce; 
      };
      # sbt = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/development/tools/build-managers/sbt/default.nix {
      #   jre = pkgs.graalvm11-ce; 
      # };
      sublime3 = 
        let
          recurseIntoAttrs = attrs: attrs // { recurseForDerivations = true; };
          sublime3Packages = recurseIntoAttrs (pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/applications/editors/sublime/3/packages.nix { });
        in
          sublime3Packages.sublime3;
    };
  };
}

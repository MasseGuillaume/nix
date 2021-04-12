{ config, pkgs, lib, ... }:

let
  screenshot = pkgs.writeShellScript "screenshot.sh" ''
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy
  '';
in
{
  # environment = {
  #   variables = {
  #     PATH="$PATH:$HOME/.npm-global";
  #     EDITOR="${pkgs.sublime3}/bin/sublime3 -w -n";
  #     SBT_OPTS="-Xms512M -Xmx2G -Xss1M -XX:+CMSClassUnloadingEnabled";
  #   };
  # };

  home.packages = with pkgs; [
    ammonite
    gnome3.gnome-screenshot
    google-cloud-sdk
    home-manager
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
  ];

  virtualisation.docker = {
    enable = true;
  };

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
        { id = "kbfnbcaeplbcioakkpcpgfkobkghlhen"; } # Grammarly for Chrome
        { id = "hdokiejnpimakedhajhdlcegeplioahd"; } # LastPass
        { id = "fmkadmapgofadopljbjfkapdkoienihi"; } # React Developer Tools
        { id = "lmhkpmbekcpmknklioeibfkpmmfibljd"; } # Redux DevTools
        { id = "clngdbkpkpeebahjckkjfobafhncgmne"; } # Stylus
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      ];
    };

    git = {
      enable = true;
      userEmail = "masgui@gmail.com";
      userName = "Guillaume Massé";
    };
    i3status-rust = {
      enable = true;
      bars.tepid = {
        icons = "awesome5";
        theme = "native";
        blocks = [
          {
            block = "focused_window";
          }
          {
            block = "net";
            device = "eth0";
          }
          # {
          #   block = "weather";
          #   service = {
          #     name = "openweathermap";
          #     inherit (secrets.openweathermap) api_key;
          #     city_id = "2155416";
          #     units = "metric";
          #   };
          # }
          {
            block = "sound";
          }
          {
            block = "time";
            format = "%d/%m %R";
          }
        ];
      };
    };
  };

   wayland.windowManager = rec {
    sway = {
      enable = true;
      systemdIntegration = false;
      config = {
        terminal = "kitty";
        modifier = "Mod4";
        focus.mouseWarping = false;
        window.border = 5;
        colors.focused = {
          border = "#FF0000";
          background = "#285577";
          text = "#ffffff";
          indicator = "#2e9ef4";
          childBorder = "#FF0000";
        };
        keybindings = lib.mkOptionDefault {
          "${sway.config.modifier}+Ctrl+p" = "exec ${./scripts/wofi-pass.sh}";
          "${sway.config.modifier}+Shift+g" = "exec ${screenshot}";
        };
        bars = [
          {
            fonts = [ "sans-serif 10" ];
            position = "top";
            statusCommand = "i3status-rs ${config.xdg.configHome}/i3status-rust/config-tepid.toml";
          }
        ];

        # DVI-D-0 | HDMI-A-0 | DisplayPort-0
        output = {
          "DVI-D-0" = {
            pos = "0 0";
            rotate = "right";
          };
          "HDMI-A-0" = {
            pos = "1080 0";
          };
          "DisplayPort-0" = {
            pos = "2160 0";
          };
        };
        input = {
          "type:keyboard" = {
            repeat_delay = "250";
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

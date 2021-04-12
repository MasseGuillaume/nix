{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/18c0c8da-6d6c-4704-a84d-fcfeeccf9fe2";
    # initrd.luks.devices = {
    #   name = "root";
    #   device = "/dev/disk/by-uuid/18c0c8da-6d6c-4704-a84d-fcfeeccf9fe2";
    #   preLVM = true;
    # };
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fontconfig = {
      defaultFonts = {
        monospace = [ "Source Code Pro" ];
        sansSerif = [ "Source Sans Pro" ];
        serif     = [ "Source Serif Pro" ];
      };
    };
    fonts = with pkgs; [
      anonymousPro
      corefonts
      dejavu_fonts
      freefont_ttf
      google-fonts
      inconsolata
      liberation_ttf
      noto-fonts
      powerline-fonts
      source-code-pro
      terminus_font
      ttf_bitstream_vera
      ubuntu_font_family
    ];
  };

  # fileSystems."/".device = "/dev/mapper/crypted";

  hardware = {
    opengl = {
      driSupport32Bit = true;
      enable = true;
    };
    pulseaudio = {
      package = pkgs.pulseaudioFull;
      enable = true;
      support32Bit = true;
    };
    cpu.intel.updateMicrocode = true;
  };

  environment = {
    variables = {
      PATH="$PATH:$HOME/.npm-global";
      EDITOR="${pkgs.sublime3}/bin/sublime3 -w -n";
      SBT_OPTS="-Xms512M -Xmx2G -Xss1M -XX:+CMSClassUnloadingEnabled";
    };
    systemPackages = 
      let
        telepresence2 = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/tools/networking/telepresence {
          pythonPackages = pkgs.python3Packages;
        };
      in
        with pkgs; [
          ammonite
          chromium
          # chromedriver
          dmenu
          docker-compose
          git
          gnome3.gnome-screenshot
          google-cloud-sdk
          htop
          inotify-tools
          jq
          killall
          kubectl
          libxml2
          loc
          mplayer
          nodejs-12_x
          ngrok
          openjdk
          pavucontrol
          postgresql
          pulumi
          pypi2nix
          sbt
          sublime3
          nodePackages.typescript
          tig
          telepresence2
          wget
          xclip
          yarn
          vscode
          zoom-us
          wineWowPackages.staging
          winetricks
        ];
  };

  time.timeZone = "America/Montreal";

  networking = {
    hostName = "bob";
    nameservers = [ "8.8.8.8" ];
  };

  virtualisation.docker = {
    enable = true;
  };

  services = {
    bloop = {
      install = true;
    };
    udev.packages = [ pkgs.yubikey-personalization ];
    xserver = {
      videoDrivers = ["amdgpu"];
      enable = true;
  
      windowManager = {        
        xmonad.enable = true;
        xmonad.enableContribAndExtras = true;
      };

      desktopManager = {
        xterm.enable = true;
      };
  
      displayManager = {
        defaultSession = "none+xmonad";

        lightdm.enable = true;

        autoLogin = {
          enable = true;
          user = "gui";
        };
          
        sessionCommands = ''
          ${pkgs.xlibs.xrdb}/bin/xrdb -all ~/.Xresources
          ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
          ${pkgs.xlibs.xset}/bin/xset r rate 200 50
          ${pkgs.hsetroot}/bin/hsetroot -solid '#002b36'


          #   DVI-D-0     |  HDMI-A-0   |    DisplayPort-0
          ${pkgs.xlibs.xrandr}/bin/xrandr --output DVI-D-0        --rotate right --pos    0x0
          ${pkgs.xlibs.xrandr}/bin/xrandr --output HDMI-A-0       --rotate right --pos 1080x0
          ${pkgs.xlibs.xrandr}/bin/xrandr --output DisplayPort-0  --rotate right --pos 2160x0
          
          xrdb "${pkgs.writeText  "xrdb.conf" ''
              URxvt.font:                 xft:Dejavu Sans Mono for Powerline:size=11
              XTerm*faceName:             xft:Dejavu Sans Mono for Powerline:size=11
              XTerm*utf8:                 2
              # URxvt.iconFile:             /usr/share/icons/elementary/apps/24/terminal.svg
              URxvt.letterSpace:          0


              #define S_base03        #002b36
              #define S_base02        #073642
              #define S_base01        #586e75
              #define S_base00        #657b83
              #define S_base0         #839496
              #define S_base1         #93a1a1
              #define S_base2         #eee8d5
              #define S_base3         #fdf6e3

              *background:            S_base03
              *foreground:            S_base0
              *fadeColor:             S_base03
              *cursorColor:           S_base1
              *pointerColorBackground:S_base01
              *pointerColorForeground:S_base1

              !! black dark/light
              *color0:                S_base02
              *color8:                S_base03
              
              !! red dark/light
              *color1:                S_red
              *color9:                S_orange
              
              !! green dark/light
              *color2:                S_green
              *color10:               S_base01
              
              !! yellow dark/light
              *color3:                S_yellow
              *color11:               S_base00
              
              !! blue dark/light
              *color4:                S_blue
              *color12:               S_base0
              
              !! magenta dark/light
              *color5:                S_magenta
              *color13:               S_violet
              
              !! cyan dark/light
              *color6:                S_cyan
              *color14:               S_base1
              
              !! white dark/light
              *color7:                S_base2
              *color15:               S_base3

              URxvt*saveLines:            32767
              XTerm*saveLines:            32767
              URxvt.colorUL:              #AED210
              URxvt.perl-ext:             default,url-select
              URxvt.keysym.M-u:           perl:url-select:select_next
              URxvt.url-select.launcher:  /usr/bin/firefox -new-tab
              URxvt.url-select.underline: true
              Xft*dpi:                    96
              Xft*antialias:              true
              Xft*hinting:                full
              URxvt.scrollBar:            false
              URxvt*scrollTtyKeypress:    true
              URxvt*scrollTtyOutput:      false
              URxvt*scrollWithBuffer:     false
              URxvt*scrollstyle:          plain
              URxvt*secondaryScroll:      true
              Xft.autohint: 0
              Xft.lcdfilter:  lcddefault
              Xft.hintstyle:  hintfull
              Xft.hinting: 1
              Xft.antialias: 1 
          ''}"
        '';
      };
    };
  };

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "agnoster";
      plugins= ["git"];
    };
  };
  
  users.users.gui = {
    isNormalUser = true;
    home = "/home/gui";
    description = "gui";

    extraGroups = [ "wheel" "docker" "libvirtd" "audio"];
    shell = "/run/current-system/sw/bin/zsh";
  };

  nixpkgs.config = {
    allowUnfree = true;

    # bloop = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/development/tools/build-managers/bloop {};
    # zoom-us = pkgs.libsForQt512.callPackage /home/gui/foos/nixpkgs/pkgs/applications/networking/instant-messengers/zoom-us { };

    chromium.enableWideVine = true;


    packageOverrides = pkgs : rec {
      # chromedriver = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/development/tools/selenium/chromedriver {
      #   gconf = pkgs.gnome2.GConf;
      # }; 

      pulumi = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/tools/admin/pulumi/default.nix { };
      # docker-compose = pkgs.python3.pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/applications/virtualization/docker-compose/default.nix { };
      vscode = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/applications/editors/vscode/vscode.nix { };
      # hyper = pkgs.callPackage /home/gui/foos/nixpkgs/pkgs/applications/misc/hyper/default.nix { };


      postgresql = pkgs.postgresql_12;
      #//.override { this = pkgs.postgresql; };

      yarn = pkgs.yarn.override { 
        nodejs = pkgs.nodejs-12_x;
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

  security = {
    sudo.wheelNeedsPassword = false;
  };

  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = false;
      # channel = https://nixos.org/channels/nixos-20.09;
    };
    stateVersion = "20.03";
  };
}

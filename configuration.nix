{ config, pkgs, lib, ... }:

{

  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];
    # kernelPackages = pkgs.linuxPackages_latest;

    # kernelParams = [ "intel_pstate=active" ];
    blacklistedKernelModules = [ "nouveau" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices.crypted.device = "/dev/disk/by-uuid/18c0c8da-6d6c-4704-a84d-fcfeeccf9fe2";
  };

  networking.networkmanager.enable = true;

  networking = {
    hostName = "bob";
    nameservers = [ "1.1.1.1" ];
  };

  time.timeZone = "America/Montreal";

  services = {
    # gvfs.enable = true;
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
          ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name left_ptr
          ${pkgs.xlibs.xset}/bin/xset r rate 200 60
          ${pkgs.hsetroot}/bin/hsetroot -solid '#002b36'

          #   DisplayPort-0     |  DisplayPort-1   |    DisplayPort-2
          ${pkgs.xlibs.xrandr}/bin/xrandr --output DisplayPort-0 --mode 1920x1080 --rotate right --pos    0x0
          ${pkgs.xlibs.xrandr}/bin/xrandr --output DisplayPort-1 --mode 1920x1080 --rotate right --pos 1080x0
          ${pkgs.xlibs.xrandr}/bin/xrandr --output DisplayPort-2 --mode 1920x1080 --rotate right --pos 2160x0
          
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


  sound.enable = true;
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

  # virtualisation.libvirtd.enable = true;

  virtualisation.docker = {
    enable = true;
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

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "curses";
    };
    steam.enable = true;
    zsh = {
      enable = true;
      shellAliases = {
        "cls" = "printf \"\\033c\"";
      };
      ohMyZsh = {
        enable = true;
        theme = "agnoster";
        plugins= ["git"];
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      
      wl-clipboard
      home-manager

      freenect
      # kinect-audio-setup
    ];
  };

  users.users.gui = {
    isNormalUser = true;
    home = "/home/gui";
    description = "gui";

    extraGroups = [ "wheel" "docker" "libvirtd" "audio"];
    shell = pkgs.zsh;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = false;
      channel = https://nixos.org/channels/nixos-20.09;

      # sudo nix-channel --list
      # nixos https://channels.nixos.org/nixos-unstable
      # nixpkgs https://channels.nixos.org/nixpkgs-unstable
      
      
      # sudo nix-channel --add https://channels.nixos.org/nixpkgs-unstable nixos
      # sudo nix-channel --add https://channels.nixos.org/nixos-20.09 nixos
    };
    stateVersion = "20.03";
  };
}

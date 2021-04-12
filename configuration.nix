{ config, pkgs, lib, ... }:

{

  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
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
    nameservers = [ "8.8.8.8" ];
  };

  time.timeZone = "America/Montreal";

  services = {
    xserver.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
  };

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

  virtualisation.libvirtd.enable = true;

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
    sway.enable = true;

    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        theme = "agnoster";
        plugins= ["git"];
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [ 
      sublime3
      home-manager
    ];
  };

  users.users.gui = {
    isNormalUser = true;
    home = "/home/gui";
    description = "gui";

    extraGroups = [ "wheel" "docker" "libvirtd" "audio"];
    shell = pkgs.zsh;
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  nixpkgs.config = {
    allowUnfree = true;
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

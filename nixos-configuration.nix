### Main Configuration
{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Grub boot loader
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };
  
  virtualisation.virtualbox.guest.enable = true;
  
  # Do not fsck the system at boot - Stops boot from failing.
  boot.initrd.checkJournalingFS = false;
  
  ## Localization
  
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "America/Los_Angeles";

  ## System Package Settings
  
  # Allow Unfree Packages
  nixpkgs.config.allowUnfree = true;
  
  # System Installed Packages
  environment.systemPackages = with pkgs; [
    htop wget nox
  ];

  ## Services

  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";

      # Enable the KDE Desktop Environment.
      desktopManager.plasma5.enable = true;

      # Enable the Auto Login System
      displayManager.auto.enable = true;
      displayManager.auto.user = "havvy";
    };

    # Enable Postgresql
    postgresql = {
      enable = false;
      enableTCPIP = false;
      port = 5432;
      package = pkgs.postgresql93;
    };

    # Apache & Mysql
    # httpd = {
    #   enable = true;
    #   adminAddr = "ryan.havvy@gmail.com";
    #   documentRoot = "/srv/siranli";
    #   enablePHP = true;
    # };
    # mysql = {
    #   enable = true;
    # };
  };

  ## User Accounts
  
  # Only users defined in this configuration exist.
  users.mutableUsers = false;

  # Havvy
  users.extraUsers.havvy = {
    name = "havvy";
    group = "users";
    uid = 1000;
    extraGroups = [ "wheel" ];
    createHome = true;
    home = "/home/havvy";
    shell = "/run/current-system/sw/bin/bash";
    hashedPassword = "$6$FogLuYMv$72ZgezrGK881OkQ2RupF7XJ1uzg1.5XGFye5n68X4Aqy6SXzWK9AF8lA3NLo5CAsbGqr.XI/g6b1WwR56gYJa0";
  };
  
  ## Security
  
  security.initialRootPassword = "$6$FogLuYMv$72ZgezrGK881OkQ2RupF7XJ1uzg1.5XGFye5n68X4Aqy6SXzWK9AF8lA3NLo5CAsbGqr.XI/g6b1WwR56gYJa0";

  ## Fonts

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts  # Micrsoft free fonts
      inconsolata  # monospaced
      ubuntu_font_family  # Ubuntu fonts
    ];
  };

  ## System Updates

  # Periodically run `nixos-rebuild`
  system.autoUpgrade.enable = false;
}

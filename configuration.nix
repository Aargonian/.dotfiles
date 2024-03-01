# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, pkgs-unstable, username, hostname, options, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config = {
    packageOverrides = pkgs: with pkgs; {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = hostname; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager = {
      sddm.enable = false;
      gdm.enable = false;
      lightdm = {
        enable = true;
        greeters.slick.enable = false;
        greeters.gtk.enable = true;
      };
    };

    xkb = {
      layout = "us";
      options = "eurosign:e,caps:super";
    };

    displayManager = {
      defaultSession = "cinnamon";
    };

    desktopManager.cinnamon.enable = true;
    desktopManager.xfce.enable = true;

    windowManager.i3 = {
      package = pkgs.i3-gaps;
      enable = true;
      extraPackages = with pkgs; [
        arandr
        dmenu
        i3status
        i3lock
      ];
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Shells
  programs.zsh.enable = true;

  # Users
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    initialPassword = "123456";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      thunderbird
      nerdfonts
      ncspot
      calibre
      terminator
      ripgrep
      tree
      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-dropbox-plugin
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin
      xfce.xfce4-terminal
      nodejs_21
      obsidian
    ];
  };

  # Editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    file
    cifs-utils
    samba
    gnome.gvfs
    git
    cmakeMinimal
    gcc
    gnumake
    rustup
    python3
    python311Packages.pynvim
    fzf # For neovim telescope plugin
    xclip # Neovim clipboard provider
    xsel # Neovim clipboard provider
    lf # Ranger-inspired explorer
    yt-dlp
    ripgrep
    mprocs
    du-dust
    zoxide
    universal-ctags
  ];

  # List services that you want to enable:
  services.openssh.enable = true;
  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome3.gvfs;
  };

  # Start and Auto-Run Thunderbird
  systemd.user.services = {
    thunderbird = {
      enable = true;
      unitConfig = {
    Description = "Thunderbird!";
    After = [ "network.target" ];
    StartLimitIntervalSec = 300;
    StartLimitBurst = 5;
      };
      serviceConfig = {
        Type = "simple";
    ExecStart = ["${pkgs.thunderbird}/bin/thunderbird --headless"];
    Restart = "always";
    RestartSec = "1s";
      };
      wantedBy = [ "default.target" ];
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "23.11"; # Did you read the comment?
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = "nix-command flakes";

  # Custom Overlays
  nixpkgs.overlays = [

  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Bad bad dirty hack to make generic linux binaries work
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = options.programs.nix-ld.libraries.default ++ (with pkgs; [ stdenv.cc.cc ] );
}

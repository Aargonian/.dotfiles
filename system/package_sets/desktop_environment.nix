{pkgs, lib, ...}:
{
  # Enable the X11 windowing system.
  services.displayManager = {
      sddm.enable = false;
      defaultSession = "cinnamon";
  };

  services.xserver = {
    enable = true;

    displayManager = {
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

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-volman
  ];

  # Enable seahorse for password inputs
  programs.seahorse.enable = true;

  # Enable gnome-keyring for passkey storage
  services.gnome.gnome-keyring.enable = true;

  # Necessary for thunar to mount external drives correctly
  services.gvfs.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # DisplayLink Driver Support
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
  services.xserver.displayManager.sessionCommands = ''
      ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
  '';

  # Note: The following command may need to be ran before the DL driver will work:
  # nix-prefetch-url --name displaylink-580.zip https://www.synaptics.com/sites/default/files/exe_files/2023-08/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu5.8-EXE.zip

  # Various useful graphics programs
  environment.systemPackages = with pkgs; [
    firefox
    gparted
    solaar # Logitech unifying receivers
    via # QMK VIA Support
    arduino-ide # Arduino IDE 2.x
  ];

  services.udev.packages = [ pkgs.via ];
}

{inputs, pkgs, lib, username, ...}:
{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager = {
      startx.enable = true;
      gdm.enable = false;
      lightdm = {
        enable = false;
        greeters.slick.enable = false;
        greeters.gtk.enable = true;
      };
    };

    xkb = {
      layout = "us";
      options = "eurosign:e,ctrl:nocaps";
    };

    desktopManager = {
      cinnamon.enable = true;
      xfce.enable = false;
      plasma6.enable = false;
    };
  };

  services.displayManager = {
      sddm.enable = false;
      defaultSession = "plasma";
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  # Enable gnome-keyring for passkey storage
  services.gnome.gnome-keyring.enable = true;

  # Necessary for thunar to mount external drives correctly
  services.gvfs.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad.naturalScrolling = true;

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

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}

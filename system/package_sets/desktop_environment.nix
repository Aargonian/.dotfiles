{pkgs, ...}:
{
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
  services.xserver.libinput.enable = true;

  # Various useful graphics programs
  environment.systemPackages = with pkgs; [
    firefox
    gparted
  ];
}

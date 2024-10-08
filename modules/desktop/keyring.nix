{lib, config, ...}:
{
  options.custom.keyring = {
    enable = lib.mkEnableOption "A keyring for storing user credentials";
  };

  config = lib.mkIf config.custom.keyring.enable {
    # We'll need polkit
    custom.polkit.enable = true;

    # Enable gnome-keyring for passkey storage
    services.gnome.gnome-keyring.enable = true;

    # Enable graphical frontend for gnome-keyring
    programs.seahorse.enable = false;
  };
}

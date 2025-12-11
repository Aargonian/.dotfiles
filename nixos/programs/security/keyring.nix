{ lib, config, ... }: with lib;
{
  options.custom.programs.security.keyring = {
    enable = mkEnableOption "A keyring for storing user credentials";
  };

  config = mkIf config.custom.programs.security.keyring.enable {
    # We'll need polkit
    custom.services.polkit.enable = true;

    # Enable gnome-keyring for passkey storage
    services.gnome.gnome-keyring.enable = true;

    # Enable graphical frontend for gnome-keyring
    programs.seahorse.enable = true;
  };
}

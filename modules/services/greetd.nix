{ lib, pkgs, config, ...}:
{
  options.custom.greetd = {
    enable = lib.mkEnableOption "Greetd greeter";
  };

  config = lib.mkIf config.custom.greetd.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --remember-user-session --time --cmd hyprland";
          user = "greeter";
        };
      };
    };

    # Ensure greetd can unlock my keyring
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
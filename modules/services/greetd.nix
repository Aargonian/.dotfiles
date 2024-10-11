{ lib, config, pkgs, ... }: with lib;
{
  options.custom.services.greetd = {
    enable = mkEnableOption "Greetd greeter";
  };

  config = mkIf config.custom.services.greetd.enable {
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

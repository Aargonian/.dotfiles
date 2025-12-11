{ lib, config, pkgs, ... }: with lib;
{
  options.custom = {
    username = mkOption {
      type = types.str;
      description = "Main admin username. Required";
      example = "aargonian";
    };
  };

  config = {
    assertions = [
      {
        assertion = config.custom.username != "";
        message = "config.custom.username must be set!";
      }
    ];

    services.logind = {
      powerKey = "hibernate";
      powerKeyLongPress = "poweroff";
      lidSwitch = "hibernate";
      lidSwitchExternalPower = "ignore";
    };

    users.users.${config.custom.username} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      initialPassword = "123456";
      extraGroups = [ "wheel" "dialout" ];
    };
  };
}

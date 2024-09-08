{lib, config, ...}:
{
  options.custom = {
    username = lib.mkOption {
      type = lib.types.str;
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

    users.users.${config.custom.username} = {
      isNormalUser = true;
      shell = config.custom.shell.package;
      initialPassword = "123456";
      extraGroups = [ "wheel" "dialout" ];
    };
  };
}

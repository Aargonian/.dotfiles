{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.git = {
    enable = mkEnableOption "Git VCS";

    name = mkOption {
      type = types.str;
      description = "Git name. Required";
      example = "Bob Jones";
    };

    email = mkOption {
      type = types.str;
      description = "Git email address. Required.";
      example = "BobJ@example.com";
    };

  };

  config.home-manager.users.${config.custom.username} = mkIf config.custom.programs.git.enable {
    assertions = [
      {
        assertion = config.custom.programs.git.name != "";
        message = "config.custom.git.name must be set!";
      }

      {
        assertion = config.custom.programs.git.email != "";
        message = "config.custom.git.email must be set!";
      }
    ];

    home.packages = with pkgs; [
      libsecret # So we can store git credentials
    ];

    programs.git = {
      enable = true;
      userName = config.custom.programs.git.name;
      userEmail = config.custom.programs.git.email;
      ignores = [
        "*.swp"
      ];

      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "store --file ~/.git-credentials";
      };

    };
  };
}

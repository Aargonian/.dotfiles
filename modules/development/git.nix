{ lib, config, pkgs, ...}:
{
  options.custom.git = {
    enable = lib.mkEnableOption "Git VCS";

    name = lib.mkOption {
      type = lib.types.str;
      description = "Git name. Required";
      example = "Bob Jones";
    };

    email = lib.mkOption {
      type = lib.types.str;
      description = "Git email address. Required.";
      example = "BobJ@example.com";
    };

  };
  config.home-manager.users.${config.custom.username} = lib.mkIf config.custom.git.enable {
    assertions = [
      {
        assertion = config.custom.git.name != "";
        message = "config.custom.git.name must be set!";
      }

      {
        assertion = config.custom.git.email != "";
        message = "config.custom.git.email must be set!";
      }
    ];

    home.packages = with pkgs; [
      libsecret # So we can store git credentials
    ];

    programs.git = {
      enable = true;
      userName = config.custom.git.name;
      userEmail = config.custom.git.email;
      ignores = [
        "*~"
        "*.swp"
        "notes"
      ];
      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
      };
    };
  };
}

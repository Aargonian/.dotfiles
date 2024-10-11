{ lib, ... }:
{
  options.custom = {
    useHomeDataDir = lib.mkEnableOption "Use Data Directory in Home for All Configurations";

    dataDirPath = lib.mkOption {
      type = lib.types.path;
      description = "Path where data is stored in the home directory";
    };

    localData = lib.mkOption {
      type = lib.types.path;
      description = "Path where data is stored in the home directory";
    };

    appData = lib.mkOption {
      type = lib.types.path;
      description = "Path where data is stored in the home directory";
    };

    trash = lib.mkOption {
      type = lib.types.path;
      description = "Path where data is stored in the home directory";
    };

    scripts = lib.mkOption {
      type = lib.types.path;
      description = "Path where data is stored in the home directory";
    };

    configs = lib.mkOption {
      type = lib.types.path;
      description = "Path where data is stored in the home directory";
    };

    cache = lib.mkOption {
      type = lib.types.path;
      description = "Path where data is stored in the home directory";
    };

    dataDirRelative = lib.mkOption {
      type = lib.types.path;
      description = "Path where data is stored in the home directory";
    };

    localDataRelative = lib.mkOption {
      type = lib.types.path;
      description = "Path where data is stored in the home directory";
    };

    appDataRelative = lib.mkOption {
      type = lib.types.path;
      description = "Path where data is stored in the home directory";
    };

    trashRelative = lib.mkOption {
      type = lib.types.path;
      description = "Path where data is stored in the home directory";
    };

    scriptsRelative = lib.mkOption {
      type = lib.types.path;
      description = "Path where data is stored in the home directory";
    };

    configsRelative = lib.mkOption {
      type = lib.types.path;
      description = "Path where data is stored in the home directory";
    };

    cacheRelative = lib.mkOption {
      type = lib.types.path;
      description = "Path where data is stored in the home directory";
    };
  };


  imports = [
    ./aargonian
    ./sh.nix
  ];
}

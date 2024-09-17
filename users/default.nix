{ lib, config, ... }:
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
  };


  imports = [
    ./packages.nix
    ./sh.nix
    ./aargonian
  ];
}

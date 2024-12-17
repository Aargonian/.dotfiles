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
      description = "Path where local machine data is stored";
    };

    appData = lib.mkOption {
      type = lib.types.path;
      description = "Path where application data is stored";
    };

    scripts = lib.mkOption {
      type = lib.types.path;
      description = "Path where scripts/programs are stored";
    };

    configs = lib.mkOption {
      type = lib.types.path;
      description = "Path where application configs are stored";
    };

    cache = lib.mkOption {
      type = lib.types.path;
      description = "Path where application cache data is stored";
    };

    dataDirRelative = lib.mkOption {
      type = lib.types.path;
      description = "Relative (to home) path where data is stored";
    };

    localDataRelative = lib.mkOption {
      type = lib.types.path;
      description = "Relative (to home) path where local machine data is stored";
    };

    appDataRelative = lib.mkOption {
      type = lib.types.path;
      description = "Relative (to home) path where applicatino data is stored";
    };

    scriptsRelative = lib.mkOption {
      type = lib.types.path;
      description = "Relative (to home) path where scripts/programs are stored";
    };

    configsRelative = lib.mkOption {
      type = lib.types.path;
      description = "Relative (to home) path where config data is stored";
    };

    cacheRelative = lib.mkOption {
      type = lib.types.path;
      description = "Relative (to home) path where cache data is stored";
    };
  };


  imports = [
    ./aargonian
    ./sh.nix
  ];
}

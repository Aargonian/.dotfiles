{ lib, config, pkgs, ... }:
let
  username = "aargonian";
  home = "/home/${username}";

  dataDirRelative   = "/Data";
  localDataRelative = "${dataDirRelative}/LocalData";
  appDataRelative   = "${localDataRelative}/AppData";
  scriptsRelative   = "${localDataRelative}/Scripts";
  configsRelative   = "${appDataRelative}/Config";
  cacheRelative     = "${appDataRelative}/Cache";

  dataDir   = "${home}${dataDirRelative}";
  localData = "${home}${localDataRelative}";
  appData   = "${home}${appDataRelative}";
  scripts   = "${home}${scriptsRelative}";
  configs   = "${home}${configsRelative}";
  cache     = "${home}${cacheRelative}";
in
{
  config = lib.mkIf config.users.aargonian.enable {
    custom = {
      # Use Data Directory Layout
      useHomeDataDir = true;

      dataDirPath = dataDir;
      localData = localData;
      appData   = appData;
      scripts   = scripts;
      configs   = configs;
      cache     = cache;

      dataDirRelative   = dataDirRelative;
      localDataRelative = localDataRelative;
      appDataRelative   = appDataRelative;
      scriptsRelative   = scriptsRelative;
      configsRelative   = configsRelative;
      cacheRelative     = cacheRelative;
    };

    home-manager.users.aargonian = lib.mkIf config.users.aargonian.enable {
      home.homeDirectory = home;
    };
  };
}

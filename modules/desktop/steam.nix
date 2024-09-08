{ lib, config, ...}:
{
  options.custom.desktop.programs.steam = {
    enable = lib.mkEnableOption "Steam and Steam Runtime";
  };

  config = lib.mkIf config.custom.desktop.programs.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    # Allow unfree packages for steam
    nixpkgs.config.allowUnfree = true;
  };
}

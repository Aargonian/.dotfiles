{lib, config, pkgs, ...}:
{
  options.custom.development.common = {
    enable = lib.mkEnableOption "Common development tools";
  };

  config = lib.mkIf config.custom.development.common.enable {
    environment.systemPackages = with pkgs; [
      git
      cmakeMinimal
      gcc
      gnumake
      automake
    ];
  };
}

{lib, pkgs, config, ...}:
{
  options.custom.development.python = {
    enable = lib.mkEnableOption "Python development tools";
  };

  config = lib.mkIf config.custom.development.python.enable {
    environment.systemPackages = with pkgs; [
      python3
    ];
  };
}

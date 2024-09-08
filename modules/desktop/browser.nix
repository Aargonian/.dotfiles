{ lib, pkgs, config, ...}:
{
  options.custom.browser = {
    enable = lib.mkEnableOption "A web browser for the desktop";
    package = lib.mkOption {
      type = lib.types.package;
      example = pkgs.qutebrowser;
      default = pkgs.firefox;
    };
  };

  config = lib.mkIf config.custom.browser.enable {
    environment.systemPackages = [
      config.custom.browser.package
    ];
  };
}

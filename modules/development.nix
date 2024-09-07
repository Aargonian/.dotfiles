{ pkgs, ... }:
{
  options.custom.development = {
    enable = lib.mkEnableOption "Common development tools";

    rust = {
      enable = lib.mkEnableOption "Rust development toolchain";
    };

    python = {
      enable = lib.mkEnableOption "Python development tools";
    };
  };

  config = lib.mkIf config.custom.development.enable {
    environment.systemPackages = with pkgs; [
      git
      cmakeMinimal
      gcc
      gnumake
    ];
  };

  config = lib.mkIf config.custom.development.rust.enable {
    rustup
  };

  config = lib.mkIf config.custom.development.python.enable {
    python3
  };
}

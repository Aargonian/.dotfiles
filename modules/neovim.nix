{ lib, pkgs, config, ... }:
{
  options.custom.neovim = {
    enable = lib.mkEnableOption "Shell programs";
  };

  config = lib.mkIf config.custom.neovim.enable {
    environment.systemPackages = with pkgs; [
      neovim
      ripgrep
    ];
  };
}

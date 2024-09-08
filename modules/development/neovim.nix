{ lib, pkgs, config, ... }:
{
  options.custom.neovim = {
    enable = lib.mkEnableOption "Shell programs";
  };

  config = lib.mkIf config.custom.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    environment.systemPackages = with pkgs; [
      ripgrep
    ];
  };
}

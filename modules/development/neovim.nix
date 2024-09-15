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
      fzf # For neovim telescope plugin
      xclip # Neovim clipboard provider
      xsel # Neovim clipboard provider
      universal-ctags # Neovim TagBar
      python311Packages.pynvim
    ];
  };
}

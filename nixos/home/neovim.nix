{ lib, config, pkgs, ... }: with lib;
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
    ripgrep
    fzf # For neovim telescope plugin
    #xclip # Neovim clipboard provider
    #xsel # Neovim clipboard provider
    universal-ctags # Neovim TagBar
    python311Packages.pynvim
  ];
}

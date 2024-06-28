{ pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim
    ripgrep # Mostly for Neovim telescope
    fzf # For neovim telescope plugin
    xclip # Neovim clipboard provider
    xsel # Neovim clipboard provider
    universal-ctags # Neovim TagBar
    python311Packages.pynvim
  ];
}

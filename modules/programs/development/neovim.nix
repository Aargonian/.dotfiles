{ lib, config, pkgs, pkgs-unstable, ... }: with lib;
{
  options.custom.programs.neovim = {
    enable = mkEnableOption "Shell programs";
  };

  config = mkIf config.custom.programs.neovim.enable {
#   programs.neovim = {
#     enable = true;
#     defaultEditor = true;
#   };

    environment.systemPackages = with pkgs; [
      pkgs-unstable.neovim
      ripgrep
      fzf # For neovim telescope plugin
      xclip # Neovim clipboard provider
      xsel # Neovim clipboard provider
      universal-ctags # Neovim TagBar
      python311Packages.pynvim
    ];
  };
}

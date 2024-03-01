{...}:
{
  # Enable zsh
  programs.zsh = {
    enable = true;
    shellAliases = {
      vim = "nvim";
    };
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
    };
  };
}

{...}:
{
  # Enable zsh
  programs.zsh = {
    enable = true;
    shellAliases = {
      vim = "nvim";
    };
    sessionVariables = {
      PATH = "$PATH:$HOME/bin";
    };
    oh-my-zsh = {
      enable = false;
      theme = "agnoster";
    };
  };
}

{...}:
{
  # Enable zsh
  programs.zsh = {
    enable = true;
    dotDir = "Data/ApplicationData/ZSH";
    history = {
      extended = true;
    };
    shellAliases = {
      vim = "nvim";
      rm = "rem";
    };
    sessionVariables = {
      DATA = "$HOME/Data";
      TRASH = "$DATA/Trash";
      PATH = "$PATH:$HOME/Data/Scripts";

      # Move XINITRC and XAUTHORITY into my data directory
      XINITRC = "$DATA/Configuration/RC/xinitrc";
      XAUTHORITY = "$DATA/Cache/X11/Xauthority";
    };
    #oh-my-zsh = {
    #  enable = false;
    #  theme = "agnoster";
    #};
  };
}

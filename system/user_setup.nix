{pkgs, username, ...}:
{
  # Shells
  programs.zsh.enable = true;

  # Users
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    initialPassword = "123456";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # Editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}

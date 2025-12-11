{ lib, config, pkgs, hostname, ... }:
let
  username = "aargonian";
in
{
  imports = [];

  options.users.aargonian = {
    enable = lib.mkEnableOption "Enable aargonian";
  };

  config = lib.mkIf config.users.aargonian.enable {
    custom = {
      ####################################################################
      # Basics
      ####################################################################
      username = username;

      ####################################################################
      # System
      ####################################################################
      programs.git = {
        enable = true;
        name = "Aaron Gorodetzky";
        email = "aaron@nytework.com";
      };

      system = {
        audio.enable = true;
        bluetooth.enable = true;
        filesystem.gvfs.enable = true;
        networking = {
          enable = true;
          hostname = hostname;
          vpn.enable = true;
        };

        # Enable Virtualbox
        virtualization.virtualbox.host = true;
      };

      ####################################################################
      # Services
      ####################################################################
      services = {
        avahi.enable = true;
        power-profiles-daemon.enable = true;
      };

      ####################################################################
      # Servers
      ####################################################################
      servers = {
        ssh.enable = true;
      };

      ####################################################################
      # Development
      ####################################################################
      #programs.neovim.enable = true;

      ####################################################################
      # UI
      ####################################################################
      fonts.useNerdFont = true;

      ####################################################################
      # Programs
      ####################################################################
      programs = {
        # Package Sets
        audio.all = true;
        development.all = true;
        messaging.all = true;
        other.all = true;
        productivity.all = true;
        security.all = true;
        shell.all = true;
        utility.all = true;

        # Individual
        firefox.enable = true;
        steam.enable = true;
        xfce4-terminal.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      bambu-studio
    ];

    home-manager.users.${username} = lib.mkIf config.users.aargonian.enable {

      home.username = username;
      home.sessionVariables = {
        EDITOR = "nvim";
      };

      imports = [
        ./zsh.nix
        ./neovim.nix
        ./hyprland.nix
      ];

      home.stateVersion = "23.11"; # Please read the comment before changing.
    };
  };
}

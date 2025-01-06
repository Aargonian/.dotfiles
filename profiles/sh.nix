{ lib, config, pkgs, ...}:
{
  config = lib.mkIf config.users.aargonian.enable {
    home-manager.users.${config.custom.username} = {
      programs.zsh = {
        enable = true;
        dotDir = lib.mkIf config.custom.useHomeDataDir "/${config.custom.configsRelative}/ZSH";

        history = {
          extended = true;
          path = lib.mkIf config.custom.useHomeDataDir "${config.custom.appData}/ZSH/zsh_history";
        };

        shellAliases = {
          vim = "nvim";
          backup = "rsync -ahv --info=progress2 --no-i-r --partial";
        };

        sessionVariables = lib.mkIf config.custom.useHomeDataDir {
          DATA      = config.custom.dataDirPath;
          LOCALDATA = config.custom.localData;
          APPDATA   = config.custom.appData;
          PATH      = "$PATH:${config.custom.scripts}";
        };

        initExtra = ''
        '';

        oh-my-zsh = {
          enable = true;
          custom = "$HOME/.config/oh-my-zsh/custom";
          theme = "spaceship";
          plugins = [
            "git"
            "battery"
          ];
          extraConfig = ''
            SPACESHIP_PROMPT_ORDER=(
              time          # Time stamps
              user          # Username section
              dir           # Current directory
              git           # Git branch
              host          # Hostname section
              exec_time     # Execution time
              line_sep      # Line break
              battery       # Battery level
              jobs          # Background jobs indicator
              exit_code     # Exit code section
              char          # Prompt character
            )

            SPACESHIP_BATTERY_SHOW="always"
            SPACESHIP_BATTERY_THRESHOLD="20"
            SPACESHIP_BATTERY_SYMBOL_CHARGING="⚡"
            SPACESHIP_BATTERY_SYMBOL_DISCHARGING="🔋"
            SPACESHIP_BATTERY_SYMBOL_FULL="🔌"
            SPACESHIP_TIME_SHOW=true
            SPACESHIP_TIME_FORMAT='%D{%H:%M:%S.%.}'
            SPACESHIP_DIR_TRUNC=0
            SPACESHIP_DIR_TRUNC_REPO=false
          '';
        };
      };


      # Ensure Spaceship is installed
      home.file = {
        ".config/oh-my-zsh/custom/themes/spaceship-prompt" = {
          source = pkgs.fetchFromGitHub {
            owner = "spaceship-prompt";
            repo = "spaceship-prompt";
            rev = "v4.16.0"; # Specify the version you want
            sha256 = "0yc2m5y2dcwnlrsv809x4gm07cmzk3s6pbq61iyjkpl3rhbr8dss";
          };
        };

        ".config/oh-my-zsh/custom/themes/spaceship.zsh-theme" = {
          text = ''
            source $HOME/.config/oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh
          '';
        };
      };
    };
  };
}

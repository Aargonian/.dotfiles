{ lib, config, pkgs, ...}:
{
  config = lib.mkIf config.users.aargonian.enable {
    home-manager.users.${config.custom.username} = {
      programs.zsh = {
        enable = true;
        dotDir = lib.mkIf config.custom.useHomeDataDir "/${config.custom.appDataRelative}/ZSH";
        history = {
          extended = true;
        };
        shellAliases = {
          vim = "nvim";
        };
        sessionVariables = lib.mkIf config.custom.useHomeDataDir {
          DATA      = config.custom.dataDirPath;
          LOCALDATA = config.custom.localData;
          APPDATA   = config.custom.appData;
          PATH      = "$PATH:${config.custom.scripts}";
        };
        initExtra = ''
          archive() {
              local dir="$1"
              local archive_name="$1"
              local checksum_file="$dir/$${archive_name}-checksums.sha256"
              local compress=false

              # Check for the --compress option
              if [[ "$2" == "--compress" ]]; then
                  compress=true
              fi

              # Generate or update the checksum file, handling symlinks correctly
              touch "$checksum_file" # Start with an empty checksum file
              while IFS= read -r -d \'\' file; do
                  if [ -L "$file" ]; then
                      echo "Generating sha256 sum for symlink $file"
                      echo -n "$(readlink "$file" | sha256sum | awk '{print $1}')  $file" >> "$checksum_file"
                  else
                      echo "Generating sha256 sum for $file"
                      sha256sum "$file" >> "$checksum_file"
                  fi
              done < <(find "$dir" -type f ! -name "$(basename "$checksum_file")" -print0)

              # Sort the checksum file
              sort -o "$checksum_file" "$checksum_file"

              # Create the tar archive, preserving symlinks and not following them
              if $compress; then
                  tar -cvJf "$${archive_name}.tar.xz" -C "$dir/.." "$(basename "$dir")"
              else
                  tar -cvf "$${archive_name}.tar" -C "$dir/.." "$(basename "$dir")"
              fi
          }

          verify() {
              local dir="$1"
              local archive_file="$2"
              local checksum_file="$dir/$(basename "$archive_file" .tar .tar.xz)-checksums.sha256"
              local temp_dir=$(mktemp -d)

              # Check if both the directory and tar file exist
              if [[ ! -d "$dir" || ! -f "$archive_file" ]]; then
                  echo "Directory or archive file not found."
                  return 1
              fi

              # Generate the checksum file if it doesn't exist
              if [[ ! -f "$checksum_file" ]]; then
                  echo "Checksum file not found. Generating now..."
                  touch "$checksum_file"
                  while IFS= read -r -d \'\' file; do
                      if [ -L "$file" ]; then
                          echo "Generating sha256 sum for symlink $file"
                          echo -n "$(readlink "$file" | sha256sum | awk '{print $1}')  $file" >> "$checksum_file"
                      else
                          echo "Generating sha256 sum for $file"
                          sha256sum "$file" >> "$checksum_file"
                      fi
                  done < <(find "$dir" -type f ! -name "$(basename "$checksum_file")" -print0)
                  sort -o "$checksum_file" "$checksum_file"
              fi

              # Extract the checksum file from the archive
              tar --extract --file="$archive_file" --strip-components=1 -C "$temp_dir" "$(basename "$checksum_file")"

              # Compare checksums
              diff_files=$(diff "$checksum_file" "$temp_dir/$(basename "$checksum_file")")

              if [[ -n "$diff_files" ]]; then
                  echo "Differences found:"
                  echo "$diff_files"
              else
                  echo "No differences found. The directory matches the tar archive."
              fi

              # Clean up
              rm -rf "$temp_dir"
          }

          unarchive() {
              local archive_file="$1"

              if [[ "$${archive_file}" == *.tar.xz ]]; then
                  tar -xvJf "$archive_file"
              elif [[ "$${archive_file}" == *.tar ]]; then
                  tar -xvf "$archive_file"
              else
                  echo "Unsupported archive format."
                  return 1
              fi
          }
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

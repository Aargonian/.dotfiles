#!/usr/bin/env bash

# List of files to link (SOURCE, DEST)
# Source path is relative to cwd
# Dest path is relative to current user home
FILES_TO_LINK=(
    "gitconfig .gitconfig"
    "zshrc .zshrc"
    "tmux.conf .tmux.conf"
)

link_config() {
  local rel_cwd="$1"
  local rel_home="$2"

  if [ -z "$rel_cwd" ] || [ -z "$rel_home" ]; then
    echo "Usage: link_config <relative_cwd_file> <relative_home_file>" >&2
    return 1
  fi

  local source="$(realpath "$rel_cwd")"
  local target="$HOME/$rel_home"

  if [ ! -f "$source" ]; then
    echo "Error: source file '$source' does not exist." >&2
    return 1
  fi

  case "$target" in
    "$HOME"*) ;;
    *) echo "Error: '$target' is not under the home directory." >&2
       return 1
       ;;
  esac

  # If target doesn't exist at all, just make the link and exit.
  if [ ! -e "$target" ]; then
    ln -s "$source" "$target"
    echo "Created symlink: $target -> $source"
    return 0
  fi

  # If target is already a symlink to the same source, we are done
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    echo "Already linked: $target -> $source"
    return 0
  fi

  # Otherwise, there's some sort of conflict. We'll prompt the user.
  while true; do
    echo ""
    echo "Conflict detected with existing file at '$target'."
    echo "[1] Replace existing with symlink to '$source'"
    echo "[2] Keep existing '$target'"
    echo "[3] Compare differences (diff)"
    echo "[4] Exit"
    read -rp "Choose an option: " choice

    case "$choice" in
      1)
        rm -f "$target"
        ln -s "$source" "$target"
        echo "Replaced existing with symlink: $target -> $source"
        return 0
        ;;
      2)
        echo "Keeping existing file."
        return 0
        ;;
      3)
        diff "$target" "$source" | less
        ;;
      4)
        echo "Exiting script."
        return 1
        ;;
      *)
        echo "Invalid choice."
        ;;
    esac
  done
}

for entry in "${FILES_TO_LINK[@]}"; do
    IFS=" " read -r src dest <<< "$entry"
    link_config "$src" "$dest"
done

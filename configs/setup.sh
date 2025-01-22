#!/usr/bin/env bash
 
# Settings
USER_HOME="$HOME"
USER_LOCAL="$USER_HOME/.local"
USER_CONFIGS="$USER_HOME/.config"
USER_CACHE="$USER_HOME/.cache"

DATA_LOC="$USER_HOME/Data"
APPDATA="$DATA_LOC/AppData"
CONFIGS="$APPDATA/configs"
SCRIPTS="$APPDATA/bin"
SOURCES="$APPDATA/src"
CACHE="$APPDATA/cache"

NEOVIM_VERSION="0.10.3"

OMZ_DIR="$USER_HOME/.oh-my-zsh"
ZSH_CUSTOM="$OMZ_DIR/custom"
ZSH_THEMES="$ZSH_CUSTOM/themes"

# Spaceship Prompt for OMZ
SSP_URL="https://github.com/spaceship-prompt/spaceship-prompt.git"
SSP_DIR="$ZSH_THEMES/spaceship-prompt"
SSP_LINK_NAME="$ZSH_THEMES/spaceship.zsh-theme"
SSP_LINK_TARGET="$SSP_DIR/spaceship.zsh-theme"

# Setup Basic Dirs
mkdir -p "$USER_HOME"
mkdir -p "$USER_CONFIGS"
mkdir -p "$DATA_LOC"
mkdir -p "$APPDATA"
mkdir -p "$CONFIGS"
mkdir -p "$SCRIPTS"
mkdir -p "$SOURCES"
mkdir -p "$CACHE"

# Store the current working directory
CWD="$(pwd -P)"

# List of files to link (SOURCE, DEST)
# Source path is relative to cwd
# Dest path is relative to current user home
FILES_TO_LINK=(
  "gitconfig .gitconfig"
  "zshrc .zshrc"
  "tmux.conf .tmux.conf"
)

# Make sure git, cmake, build-essential, zsh, tmux, and other items are installed.
sudo apt install -y git cmake build-essential zsh tmux curl wget pkg-config libssl-dev || exit 1

# Check if system is WSL2, and install wslu if true
if [ -f "/proc/sys/fs/binfmt_misc/WSLInterop" ]; then
  echo "WSL2 Detected. Installing wslu..."
  sudo apt install -y wslu || exit 1
fi

# Ensure Node and NPM are set up. Use Latest LTS (22.x) 
if ! [ -x "$(command -v npm)" ] || [ -x "$(command -v node)" ]; then
  echo "Node/NPM not found. Installing from nodesource..."
  curl -fsSL https://deb.nodesource.com/setup_lts.x -o nodesource_setup.sh || exit 1
  sudo -E bash nodesource_setup.sh || exit 1
  sudo apt install nodejs -y || exit 1

  if ! [ -x "$(command -v npm)" ] || ! [ -x "$(command -v node)" ]; then
    echo "Node failed to install for some reason. Exiting."
    exit 1
  fi

  rm nodesource_setup.sh || exit 1
fi

# Make sure rustup is setup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || exit 1

# Source the new cargo environment
source $USER_HOME/.cargo/env

# Ensure rust-analyzer is installed with rustup
rustup component add rust-analyzer || exit 1
rustup component add rust-docs || exit 1

# Ensure ncspot, dust, and ripgrep are available
cargo install du-dust || exit 1
cargo install ripgrep || exit 1
cargo install ncspot || exit 1

# Download and setup oh-my-zsh, assuming zsh is installed
if [ -x "$(command -v zsh)" ]; then
  if ! [ -d "$OMZ_DIR" ]; then
    echo "Cloning OhMyZSH"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || exit 1
    echo "Finished Cloning OhMyZSH."
  fi

  # Clone the Spaceship Prompt theme and link it
  if ! [ -d "$SSP_DIR" ]; then
    echo "Cloning spaceship-prompt for ohmyzsh."
    git clone "$SSP_URL" "$SSP_DIR" --depth=1 || exit 1
  fi

  if ! [ -L "$SSP_LINK_NAME" ]; then
    echo "Linking spaceship prompt into omz themes"
    ln -s "$SSP_LINK_TARGET" "$SSP_LINK_NAME" || exit 1
  fi

  # Change user shell to zsh
  echo "Changing user shell to zsh."
  chsh --shell "$(command -v zsh)"
fi

# Download neovim source code and build to ensure we have the latest.
if ! [ -x "$(command -v nvim)" ]; then
  echo "Neovim not installed. Building..."
  cd "$SOURCES"
  git clone "https://github.com/neovim/neovim.git" || exit 1
  cd "neovim" || exit 1
  git checkout "v$NEOVIM_VERSION" || exit 1

  # Ensure Neovim Build Prereqs are installed
  sudo apt install -y ninja-build gettext cmake unzip curl build-essential || exit 1

  # Do the build
  make CMAKE_BUILD_TYPE=RelWithDebInfo || exit 1
  sudo make install || exit 1

  # Setup my neovim config
  cd "USER_HOME"
  git clone "https://github.com/aargonian/nvim-config" "$CONFIGS/Neovim Config" || exit 1
  ln -s "$CONFIGS/Neovim Config" "$USER_CONFIGS/nvim" || exit 1
  cd "$CWD"
fi

link_config() {
  local rel_cwd="$1"
  local rel_home="$2"

  if [ -z "$rel_cwd" ] || [ -z "$rel_home" ]; then
    echo "Usage: link_config <relative_cwd_file> <relative_home_file>" >&2
    return 1
  fi

  local source="$(realpath "$rel_cwd")"
  local target="$USER_HOME/$rel_home"

  if [ ! -f "$source" ]; then
    echo "Error: source file '$source' does not exist." >&2
    return 1
  fi

  case "$target" in
    "$USER_HOME"*) ;;
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

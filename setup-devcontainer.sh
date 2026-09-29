#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

if [ ! -d "$HOME/dotfiles" ]; then
  git clone https://github.com/raulbrennersc/dotfiles "$HOME/dotfiles"
  cd "$HOME/dotfiles" || exit
  git remote set-url origin git@github.com:raulbrennersc/dotfiles.git
  cd "$HOME" || exit
fi

rm -rf "$HOME/.bashrc"

if [ -d "/workspaces" ]; then
  ln -s /workspaces ~/workspaces
fi

export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

# --- FIXES FOR THE NON-INTERACTIVE DOCKER EXEC ENVIRONMENT ---
# 1. Provide the absolute user text variable that Home Manager requires to bypass set -u
export USER=$(whoami)

# 2. Map the Debian core localization archive path cleanly into the Nix environment frame
export LOCALE_ARCHIVE=/usr/lib/locale/locale-archive
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

cd "$HOME/dotfiles" || exit
nix --extra-experimental-features "nix-command flakes" run github:nix-community/home-manager -- switch --flake .#devcontainer -b backup


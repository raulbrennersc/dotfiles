#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

if [ ! -d "$HOME/dotfiles" ]; then
  git clone https://github.com "$HOME/dotfiles"
  cd "$HOME/dotfiles" || exit
  git remote set-url origin git@github.com:raulbrennersc/dotfiles.git
  cd "$HOME" || exit
fi

rm -rf "$HOME/.bashrc"

if [ -d "/workspaces" ]; then
  ln -s /workspaces ~/workspaces
fi

export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

cd "$HOME/dotfiles" || exit
nix run github:nix-community/home-manager -- switch --flake .#devcontainer


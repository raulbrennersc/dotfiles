#!/bin/bash
export XDG_CONFIG_HOME="$HOME"/.config

mkdir -p ${HOME}/.config
ln -s ${HOME}/dotfiles/.config/nvim ${HOME}/.config/nvim
ln -s ${HOME}/dotfiles/.zshrc ${HOME}/.zshrc
ln -s ${HOME}/dotfiles/.gitconfig ${HOME}/.gitconfig
ln -s ${HOME}/dotfiles/.tmux.conf ${HOME}/dotfiles/.tmux.conf

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install fzf ripgrep neovim tmux oh-my-posh


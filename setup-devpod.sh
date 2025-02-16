#!/bin/bash
export XDG_CONFIG_HOME="$HOME"/.config

mkdir -p ${HOME}/.config
ln -s ${HOME}/dotfiles/.config/nvim ${HOME}/.config/nvim

rm -rf ${HOME}/.zshrc
rm -rf ${HOME}/.gitconfig
rm -rf ${HOME}/.tmux.conf

ln -s ${HOME}/dotfiles/.zshrc ${HOME}/.zshrc
ln -s ${HOME}/dotfiles/.gitconfig ${HOME}/.gitconfig
ln -s ${HOME}/dotfiles/.tmux.conf ${HOME}/.tmux.conf

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install fzf ripgrep neovim tmux oh-my-posh


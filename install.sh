#!/bin/bash

set -e
set -f

echo "Install packages"
sudo pacman -S git base-devel neovim flatpak zsh curl openssh \
  wezterm docker ddcutil xclip fastfetch transmission-gtk vlc \
  curl wget nerd-fonts ttf-font-awesome solaar --noconfirm

echo "Install yay"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

echo "Generate ssh keys and config"
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -P ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cp ~/dotfiles/.ssh/config ~/.ssh/config

if ! [ -d "~/dotfiles" ]; then
  git clone git@github.com:raulbrennersc/dotfiles.git ~/dotfiles
fi

echo "Create symlinks to dotfiles"
mkdir -p ~/.config
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.config/wezterm ~/.config/wezterm
ln -s ~/dotfiles/.config/solaar ~/.config/solaar

echo "Enable flathub"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Install flatpaks"
flatpak install app.zen_browser.zen io.github.alainm23.planify io.dbeaver.DBeaverCommunity -y

sudo chsh $USER -s $(which zsh)

echo "Install oh-my-zsh"
curl -L http://install.ohmyz.sh | sh

echo "Install oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | bash -s

rm -rf ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc

sudo usermod -aG docker $USER
newgrp docker

sudo systemctl enable --now docker.socket
sudo systemctl enable --now sshd
sudo systemctl enable --now systemd-resolved.service

sudo reboot

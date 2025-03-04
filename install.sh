#!/bin/bash

set -e
set -f

DOTFILES_USER=${USER}

echo "Create symlinks for dotfiles"
mkdir -p ${HOME}/.config
mkdir -p ${HOME}/.config/VSCodium/User/
mkdir -p ${HOME}/.config/alacritty
ln -s ${HOME}/dotfiles/.config/solaar ${HOME}/.config/solaar
ln -s ${HOME}/dotfiles/.config/nvim ${HOME}/.config/nvim
ln -s ${HOME}/dotfiles/.gitconfig ${HOME}/.gitconfig
ln -s ${HOME}/dotfiles/.tmux.conf ${HOME}/.tmux.conf
ln -s ${HOME}/dotfiles/.config/alacritty/alacritty.toml ${HOME}/.config/alacritty/alacritty.toml

echo "Generate ssh keys"
ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_ed25519 -q -P ""
eval "$(ssh-agent -s)"
ssh-add ${HOME}/.ssh/id_ed25519

echo "Install packages"
sudo pacman -S neovim flatpak solaar tmux zsh curl openssh alacritty docker docker-compose ripgrep ddcutil -y

echo "Install yay"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

echo "Enable Solaar"
sudo setfacl -m u:${DOTFILES_USER}:rw /dev/uinput

echo "Enable flathub"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Install Zen"
flatpak install app.zen_browser.zen io.github.alainm23.planify -y

mkdir -p ${HOME}/.fonts
echo "Install Meslo Nerd Font"
wget -P ${HOME}/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
unzip ${HOME}/.fonts/Meslo.zip -d ${HOME}/.fonts/Meslo
rm -rf ${HOME}/.fonts/Meslo.zip

echo "Install FiraCode Nerd Font"
wget -P ${HOME}/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip ${HOME}/.fonts/FiraCode.zip -d ${HOME}/.fonts/FiraCode
rm -rf ${HOME}/.fonts/FiraCode.zip

sudo chsh $DOTFILES_USER -s $(which zsh)

echo "Install oh-my-zsh"
curl -L http://install.ohmyz.sh | sh

echo "Install oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | bash -s

rm -rf ${HOME}/.zshrc
ln -s ${HOME}/dotfiles/.zshrc ${HOME}/.zshrc

echo "Install DevPod"
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod

sudo usermod -aG docker $DOTFILES_USER
newgrp docker
sudo systemctl enable --now docker.socket
sudo systemctl enable --now sshd
systemctl --user enable --now gcr-ssh-agent.socket

sudo reboot

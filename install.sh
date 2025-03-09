#!/bin/bash

set -e
set -f

echo "Install packages"
sudo pacman -S git base-devel neovim flatpak tmux zsh curl openssh \
  alacritty docker docker-compose ddcutil xclip spotify-launcher \
  fastfetch transmission-gtk vlc nerd-fonts ttf-font-awesome fuzzel --noconfirm

if ! [ -d "~/dotfiles" ]; then
  git clone https://github.com/raulbrennersc/dotfiles.git ~/dotfiles
  cd ~/dotfiles
  git remote set-url origin git@github.com:raulbrennersc/dotfiles.git
  cd
fi

echo "Create symlinks for dotfiles"
mkdir -p ~/.config
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.config/alacritty ~/.config/alacritty
ln -s ~/dotfiles/.config/sway ~/.config/sway
ln -s ~/dotfiles/.config/waybar ~/.config/waybar

echo "Generate ssh keys"
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -P ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

echo "Install yay"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

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

echo "Install DevPod"
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod

sudo usermod -aG docker $USER
newgrp docker

sudo systemctl enable --now docker.socket
sudo systemctl enable --now sshd

devpod provider add docker
devpod provider use docker
devpod ide use none

sudo reboot

#!/bin/bash

set -e
set -f

echo "Install ArchLinux packages"
sudo pacman -S --noconfirm git base-devel flatpak zsh curl openssh \
  docker ddcutil xclip fastfetch transmission-gtk vlc unzip neovim \
  cmatrix fd curl wget nerd-fonts ttf-font-awesome solaar cargo \
  spotify-launcher steam papirus-icon-theme gnome-themes-extra \
  pacman-contrib

echo "Install yay"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd

echo "Generate ssh keys and config"
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -P ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

if ! [ -d "~/dotfiles" ]; then
  echo "Clone dotfiles"
  git clone https://github.com/raulbrennersc/dotfiles.git ~/dotfiles
fi

echo "Create symlinks to dotfiles"
mkdir -p ~/.config/dconf
mkdir -p ~/.config/autostart
mkdir -p ~/.config/environment.d
mkdir -p ~/.local/share/applications
mkdir -p ~/.docker/
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.config/wezterm ~/.config/wezterm
ln -s ~/dotfiles/.config/solaar ~/.config/solaar
ln -s ~/dotfiles/.config/sway ~/.config/sway
ln -s ~/dotfiles/.config/waybar ~/.config/waybar
ln -s ~/dotfiles/.config/cava ~/.config/cava
ln -s ~/dotfiles/.config/dconf/user.d ~/.config/dconf/user.d
cp ~/dotfiles/.config/environment.d/mangohud.conf ~/.config/environment.d/mangohud.conf
cp ~/dotfiles/.docker/config.json ~/.docker/config.json
cp ~/dotfiles/autostart/solaar.desktop ~/.config/solaar.desktop
cp ~/dotfiles/.ssh/config ~/.ssh/config

echo "Enable flathub"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Install flatpaks"
flatpak install -y app.zen_browser.zen io.github.alainm23.planify io.dbeaver.DBeaverCommunity \
  com.discordapp.Discord com.mattjakeman.ExtensionManager

echo "Install Postman"
curl -L -o postman.tar.gz https://dl.pstmn.io/download/latest/linux_64
mkdir ~/Applications/
tar xzvf postman.tar.gz -C Applications/
sudo ln -s ~/Applications/Postman/Postman /usr/bin/postman
cp ~/dotfiles/.config/applications/postman.desktop ~/.local/share/applications/postman.desktop

echo "Apply GNOME customization"
dconf compile ~/.config/dconf/user ~/.config/dconf/user.d
sudo dconf update

sudo chsh $USER -s $(which zsh)

echo "Install oh-my-zsh"
curl -L http://install.ohmyz.sh | sh

echo "Install oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | bash -s

rm -rf ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc

sudo usermod -aG docker $USER
newgrp docker

sudo systemctl enable systemd-resolved.service
sudo systemctl enable sshd
sudo systemctl enable docker.socket
sudo systemctl enable docker.service

sudo reboot

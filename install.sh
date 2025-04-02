#!/bin/bash

set -e
set -f

if command -v apt 2>&1 >/dev/null; then
  echo "Install Debian packages"
  sudo apt install -y git build-essential ddcutil wl-clipboard cava \
    solaar zsh curl openssh fastfetch transmission vlc wget \
    fonts-font-awesome cmatrix fd-find

  wget https://github.com/wezterm/wezterm/releases/download/nightly/wezterm-nightly.Debian12.deb -O wezterm.deb
  sudo apt install ./wezterm.deb -y
  rm -rf ./weztern.deb

  echo "Install Meslo Nerd Font"
  wget -P ~/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
  unzip ~/.fonts/Meslo.zip -d ~/.fonts/Meslo
  rm -rf ~/.fonts/Meslo.zip

  echo "Install FiraCode Nerd Font"
  wget -P ~/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
  unzip ~/.fonts/FiraCode.zip -d ~/.fonts/FiraCode
  rm -rf ~/.fonts/FiraCode.zip

  echo "Install JetBrainsMono Nerd Font"
  wget -P ~/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip ~/.fonts/JetBrainsMono.zip -d ~/.fonts/JetBrainsMono
  rm -rf ~/.fonts/JetBrainsMono.zip

elif command -v pacman 2>&1 >/dev/null; then
  echo "Install ArchLinux packages"
  sudo pacman -S --noconfirm git base-devel flatpak zsh curl openssh \
    docker ddcutil xclip fastfetch transmission-gtk vlc \
    cmatrix fd curl wget nerd-fonts ttf-font-awesome solaar

  echo "Install yay"
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  yay -S wezterm-git cava
fi

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm -rf nvim-linux-x86_64.tar.gz

echo "Generate ssh keys and config"
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -P ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cp ~/dotfiles/.ssh/config ~/.ssh/config

if ! [ -d "~/dotfiles" ]; then
  git clone git@github.com:raulbrennersc/dotfiles.git ~/dotfiles
fi

echo "Create symlinks to dotfiles"
mkdir -p ~/.config/
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.config/wezterm ~/.config/wezterm
ln -s ~/dotfiles/.config/solaar ~/.config/solaar
ln -s ~/dotfiles/.config/sway ~/.config/sway
ln -s ~/dotfiles/.config/waybar ~/.config/waybar
ln -s ~/dotfiles/.config/cava ~/.config/cava
ln -s ~/dotfiles/.config/environment.d ~/.config/environment.d

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

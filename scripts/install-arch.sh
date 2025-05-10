#!/bin/bash

echo "Install ArchLinux packages"
sudo pacman -S --noconfirm git base-devel flatpak zsh curl openssh \
  docker ddcutil xclip fastfetch transmission-gtk vlc unzip neovim \
  cmatrix fd curl wget nerd-fonts ttf-font-awesome solaar cargo \
  spotify-launcher steam papirus-icon-theme gnome-themes-extra \
  pacman-contrib networkmanager-openvpn xorg-xhost libnma tmux \
  mangohud networkmanager-openvpn-gnome sqlite3

echo "Install yay"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd

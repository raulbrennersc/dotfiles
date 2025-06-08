#!/bin/bash

echo "Install ArchLinux packages"
sudo pacman -Syu --noconfirm git base-devel flatpak curl openssh \
  ddcutil xclip vlc unzip cmatrix fd curl solaar fastfetch cava \
  bash-completion networkmanager-openvpn vim qbittorrent tmux \
  chromium alacritty libnma ripgrep mangohud sqlite fuse2 \
  neovim docker papirus-icon-theme wget nerd-fonts discord \
  ttf-font-awesome spotify-launcher xorg-xhost pacman-contrib \
  dbeaver ttf-nerd-fonts-symbols-mono \
  gnome-console gnome-themes-extra gnome-system-monitor \
  gnome-shell-extension-appindicator

echo "Install yay"
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd

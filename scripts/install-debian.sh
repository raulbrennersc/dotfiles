#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "Install Debian packages"
sudo apt-get update
sudo apt-get install -y git build-essential flatpak curl openssh-server \
  ddcutil xclip vlc unzip cmatrix fd-find curl systemd-resolved solaar \
  fastfetch cava extrepo bash-completion network-manager-openvpn vim \
  qbittorrent chromium alacritty libnma-dev ripgrep tmux mangohud \
  sqlite3 libfuse2t64 papirus-icon-theme \
  network-manager-openvpn-gnome gnome-themes-extra gnome-console \
  gnome-software-plugin-flatpak gnome-shell-extension-system-monitor \
  gnome-shell-extension-appindicator

sudo systemctl restart systemd-resolved.service

# TODO: Replace manual install for extrepo packages:
# echo "Add extrepo repositories"
# sudo extrepo enable librewolf docker spotify
# echo "Install packages from extrepo"
# sudo apt-get install -y spotify-client librewolf \
#   docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Add extrepo repositories"
sudo extrepo enable librewolf
echo "Install packages from extrepo"
sudo apt-get update
sudo apt-get install -y librewolf

echo "Add additional repositories"
echo "-- Docker"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian trixie stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

echo "-- Spotify"
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

echo "-- Wezterm"
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg

echo "Install packages from additional repositories"
sudo apt-get update
sudo apt-get install -y \
  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
  spotify-client \
  wezterm-nightly

echo "Download .deb files"
echo "-- DBeaver"
wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb -O dbeaver.deb

echo "-- Discord"
wget https://discord.com/api/download?platform=linux -O discord.deb

echo "Install packages from .deb files"
sudo apt-get install -y ./discord.deb ./dbeaver.deb
rm -rf ./discord.deb ./dbeaver.deb

echo "Install Neovim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm -rf nvim-linux-x86_64.tar.gz

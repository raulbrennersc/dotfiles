#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
export NONINTERACTIVE=1

echo "Install Debian packages"
sudo apt-get update
sudo apt-get install -y git build-essential flatpak curl openssh-server \
  ddcutil xclip vlc unzip cmatrix fd-find curl systemd-resolved solaar \
  fastfetch cava extrepo zsh network-manager-openvpn vim libfuse2t64 \
  qbittorrent chromium alacritty libnma-dev ripgrep tmux mangohud \
  sqlite3 papirus-icon-theme \
  network-manager-openvpn-gnome gnome-themes-extra gnome-console \
  gnome-software-plugin-flatpak gnome-shell-extension-system-monitor \
  gnome-shell-extension-appindicator

sudo systemctl restart systemd-resolved.service

echo "Add extrepo repositories"
sudo extrepo enable librewolf docker spotify steam
echo "Install packages from extrepo"
sudo apt-get update
sudo apt-get install -y librewolf spotify-client steam \
  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Add additional repositories"
echo "-- Wezterm"
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg

echo "Install packages from additional repositories"
sudo apt-get update
sudo apt-get install -y wezterm-nightly

echo "Download .deb files"
echo "-- DBeaver"
wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb -O dbeaver.deb

echo "Install packages from .deb files"
sudo apt-get install -y ./dbeaver.deb
rm -rf ./dbeaver.deb

echo "Install Neovim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm -rf nvim-linux-x86_64.tar.gz

wget -O- raulbrennersc.dev/dotfiles/install-dotfiles.sh | bash -s

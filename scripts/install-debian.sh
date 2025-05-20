#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "Install Debian packages"
sudo apt-get update
sudo apt-get install -y git build-essential flatpak zsh curl openssh-server \
  ddcutil xclip transmission vlc unzip cmatrix fd-find curl systemd-resolved \
  solaar cargo papirus-icon-theme gnome-themes-extra fastfetch cava extrepo \
  network-manager-openvpn network-manager-openvpn-gnome ca-certificates \
  gnome-console libnma-dev vim ripgrep tmux mangohud sqlite3 libfuse2t64 \
  gnome-shell-extension-appindicator gnome-shell-extension-system-monitor \
  gnome-shell-extension-manager gnome-shell-extension-tiling-assistant \
  gnome-authenticator qbittorrent chromium

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

echo "Install Neovim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm -rf nvim-linux-x86_64.tar.gz

echo "Install docker"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian trixie stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "Install Spotify"
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client

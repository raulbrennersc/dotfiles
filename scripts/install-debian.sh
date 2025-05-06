!#/bin/bash

echo "Install Debian packages"
sudo apt-get update
sudo apt-get install -y git build-essential flatpak zsh curl openssh-server \
  ddcutil xclip transmission vlc unzip cmatrix fd-find curl systemd-resolved \
  solaar cargo papirus-icon-theme gnome-themes-extra fastfetch cava extrepo \
  network-manager-openvpn libnma-dev ca-certificates vim ripgrep tmux

sudo systemctl restart systemd-resolved.service

# TODO: Replace manual install for extrepo packages:
# echo "Add extrepo repositories"
# sudo extrepo enable librewolf docker google-chrome spotify steam
# echo "Install packages from extrepo"
# sudo apt-get install -y google-chrome spotify-client steam librewolf \
#   docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Add extrepo repositories"
sudo extrepo enable librewolf
echo "Install packages from extrepo"
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

echo "Install Google Chrome"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb
sudo apt-get install ./chrome.deb -y
rm -rf ./chrome.deb

echo "Install Spotify"
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client

echo "Install Steam"
wget https://cdn.fastly.steamstatic.com/client/installer/steam.deb -O steam.deb
sudo apt-get install ./steam.deb -y
rm -rf ./steam.deb

echo "Install Wezterm"
wget https://github.com/wezterm/wezterm/releases/download/nightly/wezterm-nightly.Debian12.deb -O wezterm.deb
sudo apt-get install ./wezterm.deb -y
rm -rf ./wezterm.deb

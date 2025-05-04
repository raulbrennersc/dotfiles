#!/bin/bash

set -e
set -f

echo "Install Debian packages"
sudo apt-get update
sudo apt-get install -y git build-essential flatpak zsh curl openssh-server \
  ddcutil xclip transmission vlc unzip cmatrix fd-find curl systemd-resolved \
  solaar cargo papirus-icon-theme gnome-themes-extra fastfetch cava extrepo \
  network-manager-openvpn libnma-dev ca-certificates vim ripgrep

sudo systemctl restart systemd-resolved.service

# TODO: change manual usage of additional repositories to use extrepo
# sudo extrepo enable librewolf google-chrome spotify steam docker
# sudo apt-get install librewolf google-chrome spotify-client steam \
#   docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Install Neovim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
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

echo "Generate ssh keys and config"
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -P ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

if ! [ -d "~/dotfiles" ]; then
  echo "Clone dotfiles"
  git clone -b debian https://github.com/raulbrennersc/dotfiles.git ~/dotfiles
  cd ~/dotfiles
  git remote set-url origin git@github.com:raulbrennersc/dotfiles.git
  cd
fi

echo "Create symlinks to dotfiles"
mkdir -p ~/.config/dconf
mkdir -p ~/.config/autostart
mkdir -p ~/.config/environment.d
mkdir -p ~/.docker/
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.config/wezterm ~/.config/wezterm
ln -s ~/dotfiles/.config/solaar ~/.config/solaar
ln -s ~/dotfiles/.config/cava ~/.config/cava
ln -s ~/dotfiles/.config/dconf/user.d ~/.config/dconf/user.d
cp ~/dotfiles/.config/environment.d/mangohud.conf ~/.config/environment.d/mangohud.conf
cp ~/dotfiles/.docker/config.json ~/.docker/config.json
cp ~/dotfiles/.config/autostart/solaar.desktop ~/.config/solaar.desktop
cp ~/dotfiles/.ssh/config ~/.ssh/config
sudo cp ~/dotfiles/.config/applications/org.wezfurlong.wezterm.desktop /usr/share/applications/org.wezfurlong.wezterm.desktop
sudo ln -s ~/dotfiles/scripts/devcontainers.sh /usr/bin/devcontainer

echo "Enable flathub"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Install flatpaks"
flatpak install -y app.zen_browser.zen io.github.alainm23.planify io.dbeaver.DBeaverCommunity com.mattjakeman.ExtensionManager

echo "Install Postman"
curl -L -o postman.tar.gz https://dl.pstmn.io/download/latest/linux_64
mkdir ~/Applications/
tar xzvf postman.tar.gz -C Applications/
sudo ln -s ~/Applications/Postman/Postman /usr/bin/postman
sudo cp ~/dotfiles/.config/applications/postman.desktop /usr/share/applications/postman.desktop
rm -rf postman.tar.gz

echo "Install JetBrainsMono NF"
wget -P ~/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip ~/.fonts/JetBrainsMono.zip -d ~/.fonts/JetBrainsMono
rm -rf ~/.fonts/JetBrainsMono.zip

echo "Apply GNOME customization"
dconf compile ~/.config/dconf/user ~/.config/dconf/user.d
sudo dconf update

sudo chsh $USER -s /usr/bin/zsh

echo "Install oh-my-zsh"
curl -L http://install.ohmyz.sh | sh

echo "Install oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | bash -s

rm -rf ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.zprofile ~/.zprofile

sudo usermod -aG docker $USER
newgrp docker

sudo systemctl enable systemd-resolved.service
sudo systemctl enable docker.socket
sudo systemctl enable docker.service
systemctl --user enable gcr-ssh-agent.socket

sudo reboot

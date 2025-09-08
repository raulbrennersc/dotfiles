#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

# if command -v apt 2>&1 >/dev/null; then
#   ~/dotfiles/scripts/install-debian.sh
# elif command -v pacman 2>&1 >/dev/null; then
#   ~/dotfiles/scripts/install-debian.sh
# fi

echo "Install Debian packages"
sudo dpkg --add-architecture i386
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
sudo sed -i 's/# - non-free/- non-free/' /etc/extrepo/config.yaml

echo "Add extrepo repositories"
sudo extrepo enable librewolf
sudo extrepo enable docker-ce
sudo extrepo enable spotify
# sudo extrepo enable steam
echo "Install packages from extrepo"
sudo apt-get update
sudo apt-get install -y librewolf spotify-client \
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

echo "-- Dbeaver"
wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb -O dbeaver.deb

echo "-- Steam"
wget https://cdn.fastly.steamstatic.com/client/installer/steam.deb -O steam.deb

echo "Install packages from .deb files"
sudo apt-get install -y ./steam.deb ./dbeaver.deb
rm -rf ./steam.deb ./dbeaver.deb

sudo sed -i 's/\/usr\/share\/dbeaver-ce\/dbeaver.png/dbeaver/' /usr/share/applications/dbeaver-ce.desktop
sudo sed -i 's/Name=dbeaver-ce/Name=DBeaver/' /usr/share/applications/dbeaver-ce.desktop

echo "Install Neovim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm -rf nvim-linux-x86_64.tar.gz

if ! [ -d "~/dotfiles" ]; then
  echo "Clone dotfiles"
  git clone https://github.com/raulbrennersc/dotfiles.git ~/dotfiles
fi
cd ~/dotfiles
git remote set-url origin git@github.com:raulbrennersc/dotfiles.git
cd

echo "Generate ssh keys and config"
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -P ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

echo "Create symlinks to dotfiles"
mkdir -p ~/.config/autostart ~/.config/dconf ~/.config/environment.d ~/.config/git ~/.config/tmux ~/.config/fastfetch ~/.docker/
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dotfiles/.config/git/config ~/.config/git/config
ln -s ~/dotfiles/.config/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
ln -s ~/dotfiles/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -s ~/dotfiles/.config/wezterm ~/.config/wezterm
ln -s ~/dotfiles/.config/alacritty ~/.config/alacritty
ln -s ~/dotfiles/.config/solaar ~/.config/solaar
ln -s ~/dotfiles/.config/cava ~/.config/cava
ln -s ~/dotfiles/.config/MangoHud ~/.config/MangoHud
ln -s ~/dotfiles/.config/dconf/user.d ~/.config/dconf/user.d
cp ~/dotfiles/.config/environment.d/mangohud.conf ~/.config/environment.d/mangohud.conf
cp ~/dotfiles/.docker/config.json ~/.docker/config.json
cp ~/dotfiles/.config/autostart/solaar.desktop ~/.config/autostart/solaar.desktop
cp ~/dotfiles/.config/autostart/startup.desktop ~/.config/autostart/startup.desktop
cp ~/dotfiles/.ssh/config ~/.ssh/config
sudo ln -s ~/dotfiles/scripts/devcontainers.sh /usr/bin/devcontainer

echo "Enable flathub"
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Install flatpaks"
flatpak install -y re.sonny.Junction com.belmoussaoui.Authenticator com.mattjakeman.ExtensionManager

echo "Install Postman"
curl -L -o postman.tar.gz https://dl.pstmn.io/download/latest/linux_64
mkdir ~/Applications/
tar xzvf postman.tar.gz -C Applications/
sudo ln -s ~/Applications/Postman/Postman /usr/bin/postman
sudo cp ~/dotfiles/.config/applications/postman.desktop /usr/share/applications/postman.desktop
rm -rf postman.tar.gz

echo "Install Hack Nerd Font"
wget -P ~/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip
unzip ~/.fonts/Hack.zip -d ~/.fonts/Hack
rm -rf ~/.fonts/Hack.zip

echo "Apply GNOME customization"
dconf compile ~/.config/dconf/user ~/.config/dconf/user.d
sudo dconf update

echo "Set default browser"
xdg-settings set default-web-browser re.sonny.Junction.desktop

echo "Install oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | bash -s

echo "Install oh-my-zsh"
curl -L http://install.ohmyz.sh | sh

sudo chsh -s $(which zsh) $(whoami)
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

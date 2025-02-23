#!/bin/bash

set -e
set -f

DOTFILES_USER=${USER}

echo "Create symlinks for dotfiles"
mkdir -p ${HOME}/.config
mkdir -p ${HOME}/.config/VSCodium/User/
ln -s ${HOME}/dotfiles/.config/solaar ${HOME}/.config/solaar
ln -s ${HOME}/dotfiles/.config/nvim ${HOME}/.config/nvim
ln -s ${HOME}/dotfiles/.zshrc ${HOME}/.zshrc
ln -s ${HOME}/dotfiles/.gitconfig ${HOME}/.gitconfig
ln -s ${HOME}/dotfiles/.tmux.conf ${HOME}/.tmux.conf

echo "Generate ssh keys"
ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_ed25519 -q -P ""
eval "$(ssh-agent -s)"
ssh-add ${HOME}/.ssh/id_ed25519

echo "Install DEB packages"
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
  | gpg --dearmor \
  | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
  | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update
sudo apt install build-essential flatpak solaar codium tmux zsh curl -y

echo "Enable Solaar"
sudo setfacl -m u:${DOTFILES_USER}:rw /dev/uinput

echo "Enable flathub"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Install Flatpaks"
flatpak install app.zen_browser.zen io.github.alainm23.planify -y

echo "Install homebrew"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

mkdir -p ${HOME}/.fonts
echo "Install Meslo Nerd Font"
wget -P ${HOME}/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
unzip ${HOME}/.fonts/Meslo.zip -d ${HOME}/.fonts/Meslo
rm -rf ${HOME}/.fonts/Meslo.zip

echo "Install FiraCode Nerd Font"
wget -P ${HOME}/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip ${HOME}/.fonts/FiraCode.zip -d ${HOME}/.fonts/FiraCode
rm -rf ${HOME}/.fonts/FiraCode.zip

sudo chsh $DOTFILES_USER -s $(which zsh)

echo "Install oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Install oh-my-posh"
brew install jandedobbeleer/oh-my-posh/oh-my-posh

rm -rf ${HOME}/.zshrc
ln -s ${HOME}/dotfiles/.zshrc ${HOME}/.zshrc

echo "Install docker ce"
curl -fsSL https://get.docker.com -o- | sh
sudo groupadd docker
sudo usermod -aG docker $DOTFILES_USER
newgrp docker

sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service
sudo systemctl enable --now sshd

echo "Install DevPod"
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod

sudo reboot

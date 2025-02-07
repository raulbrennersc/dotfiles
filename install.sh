#!/bin/bash

set -e
set -f

DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOTFILES_USER=raul

echo "Create symlinks for dotfiles"
mkdir -p ${HOME}/.config
mkdir -p ${HOME}/.var/app/com.vscodium.codium/config/VSCodium/User/
ln -s ${HOME}/dotfiles/.config/solaar ${HOME}/.config/solaar
ln -s ${HOME}/dotfiles/.zshrc ${HOME}/.zshrc
ln -s ${HOME}/dotfiles/vscodium/settings.json ${HOME}/.var/app/com.vscodium.codium/config/VSCodium/User/settings.json

echo "Generate ssh keys"
ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_ed25519 -q -P "" -C "raulbrennersc"
eval "$(ssh-agent -s)"
ssh-add ${HOME}/.ssh/id_ed25519

if command -v dnf &> /dev/null;
then
  echo "Install Fedora packages"
  sudo dnf install flatpak solaar -y
  sudo dnf install @development-tools -y
elif command -v apt &> /dev/null;
then
  echo "Install Debian"
  sudo apt install build-essential flatpak solaar -y
fi

echo "Enable Solaar"
sudo setfacl -m u:${DOTFILES_USER}:rw /dev/uinput

echo "Enable flathub"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Install VSCodium"
flatpak install com.vscodium.codium -y

echo "Install Zen"
flatpak install app.zen_browser.zen -y 

echo "Install codium extensions"
while read p; do
  flatpak run com.vscodium.codium --install-extension "$p"
done < ${DOTFILES_DIR}/vscodium/extensions

echo "Install homebrew"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install gcc

mkdir -p ${HOME}/.fonts
echo "Install Meslo NF"
wget -P ${HOME}/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
unzip ${HOME}/.fonts/Meslo.zip -d ${HOME}/.fonts/Meslo
rm -rf ${HOME}/.fonts/Meslo.zip

echo "Install FiraCode NF"
wget -P ${HOME}/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip ${HOME}/.fonts/FiraCode.zip -d ${HOME}/.fonts/FiraCode
rm -rf ${HOME}/.fonts/FiraCode.zip

echo "Install zsh"
brew install zsh

sudo chsh $DOTFILES_USER -s $(which zsh)

echo "Install oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Install oh-my-posh"
brew install jandedobbeleer/oh-my-posh/oh-my-posh

echo "Install docker ce"
curl -fsSL https://get.docker.com -o- | sh
sudo groupadd docker
sudo usermod -aG docker $DOTFILES_USER
newgrp docker

sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service

echo "Install DevPod"
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod

sudo reboot

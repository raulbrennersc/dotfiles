#!/bin/bash

set -e
set -f

DOTFILES_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOTFILES_USER=raul

echo "Create symlinks for dotfiles"
ln -s ${DOTFILES_DIR}/.config ${HOME}/.config
ln -s ${DOTFILES_DIR}/.zshrc ${HOME}/.zshrc

echo "Generate ssh keys"
ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_ed25519 -q -P "" -C "raulbrennersc"
eval "$(ssh-agent -s)"
ssh-add ${HOME}/.ssh/id_ed25519


mkdir -p ~/.config/VSCodium/User
ln -s ${DOTFILES_DIR}/vscodium/settings.json ~/.config/VSCodium/User/settings.json

echo "Install packages"
sudo apt install solaar -y

sudo chsh $DOTFILES_USER -s $(which zsh)

echo "Install codium extensions"
while read p; do
  codium --install-extension "$p"
done < ${DOTFILES_DIR}/vscodium/extensions

echo "Install homebrew"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

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

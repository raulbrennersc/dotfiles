#!/usr/bin/env bash

set -e
set -f

echo "Copy dotfiles"
cp -r $(pwd)/dotfiles/.config ${HOME}
cp -r $(pwd)/dotfiles/.ssh ${HOME}
cp $(pwd)/dotfiles/zsh/.zshrc ${HOME}/.zshrc

echo "Generating ssh keys"
ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_personal -q -P ""
ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_work -q -P ""
eval "$(ssh-agent -s)"
ssh-add ${HOME}/.ssh/id_personal
ssh-add ${HOME}/.ssh/id_work

echo "Installing packages"
sudo dnf install solaar zsh -y
chsh -s $(which zsh)

echo "Install Meslo NF"
wget -P ${HOME}/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
unzip ${HOME}/.fonts/Meslo.zip -d ${HOME}/.fonts/Meslo
rm -rf ${HOME}/.fonts/Meslo.zip

echo "Install FiraCode NF"
wget -P ${HOME}/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip ${HOME}/.fonts/FiraCode.zip -d ${HOME}/.fonts/FiraCode
rm -rf ${HOME}/.fonts/FiraCode.zip

echo "Install oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | bash -s

echo "Install DevPod"
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod

echo "Install docker ce"
curl -fsSL https://get.docker.com -o- | sh
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

sudo reboot

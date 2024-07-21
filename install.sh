#!/usr/bin/env bash

set -e
set -f

echo "Copy dotfiles"
cp -r $(pwd)/dotfiles/.config ${HOME}
cp $(pwd)/dotfiles/zsh/.zshrc ${HOME}/.zshrc

if ! [ -f "${HOME}/.ssh/id_ed25519" ]; then
  echo "Generating ssh keys"
  ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_ed25519 -q -P ""
  eval "$(ssh-agent -s)"
  ssh-add ${HOME}/.ssh/id_ed25519
fi

echo "Installing packages"
sudo apt update
sudo apt install nala -y
sudo nala update
sudo nala install build-essential \
  zsh \
  xclip \
  curl \
  unzip \
  ripgrep \
  -y

chsh -s $(which zsh)

echo "Install Homebrew"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "Install neovim"
brew install neovim

echo "Install oh my zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "Install nvm"
PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash'
source ${HOME}/.nvm/nvm.sh

echo "Install Meslo NF"
wget -P ${HOME}/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
unzip ${HOME}/.fonts/Meslo.zip -d ${HOME}/.fonts/Meslo
rm -rf ${HOME}/.fonts/Meslo.zip

echo "Install FiraCode NF"
wget -P ${HOME}/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip ${HOME}/.fonts/FiraCode.zip -d ${HOME}/.fonts/FiraCode
rm -rf ${HOME}/.fonts/FiraCode.zip

echo "Install oh-my-posh"
brew install jandedobbeleer/oh-my-posh/oh-my-posh

echo "Install docker ce"
curl -fsSL https://get.docker.com -o- | sh
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

echo "Install LazyVim"
git clone https://github.com/LazyVim/starter ${HOME}/.config/nvim
nvim --headless +qa
nvim --headless "+Lazy! sync" +qa

sudo reboot
#!/usr/bin/env bash

set -e
set -f

sudo apt update
# "Installing build-essential"
sudo apt install build-essential -y

###
# Install curl
###
if ! command -v <curl> &> /dev/null
then
    sudo apt install curl
fi

###
# Install unzip
###
if ! command -v <unzip> &> /dev/null
then
    sudo apt install unzip
fi

###
# Install zsh
###
printf "\n🚀 Installing zsh\n"
sudo apt install zsh -y

###
# Install oh my zsh
###
printf "\n🚀 Installing oh-my-zsh\n"
if [ -d "${HOME}/.oh-my-zsh" ]; then
  printf "oh-my-zsh is already installed\n"
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

###
# Installing powerlevel10k
###
printf "\n🚀 Installing powerlevel10k\n"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k


###
# Installing dotfiles
###
printf "\n🚀 Installing dotfiles\n"
cp $(pwd)/dotfiles/zsh/.zshrc ${HOME}/.zshrc
cp $(pwd)/dotfiles/zsh/.zprofile ${HOME}/.zprofile
cp $(pwd)/dotfiles/zsh/.p10k.zsh ${HOME}/.p10k.zsh
cp $(pwd)/dotfiles/hyper/.hyper.js ${HOME}/.hyper.js


echo "Installing NVM"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.nvm/nvm.sh

###
# Installing font
###
wget -P ~/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
unzip ~/.fonts/Meslo.zip -d ~/.fonts/Meslo
rm -rf ~/.fonts/Meslo.zip


###
# Downloading AppImages
###
mkdir -p ~/Applications
curl https://releases.hyper.is/download/AppImage -o ~/Applications/hyper.AppImage

###
# Installing appimaged
###
wget -c https://github.com/$(wget -q https://github.com/probonopd/go-appimage/releases/expanded_assets/continuous -O - | grep "appimaged-.*-x86_64.AppImage" | head -n 1 | cut -d '"' -f 2) -P ~/Applications/
chmod +x ~/Applications/appimaged-*.AppImage

# Launch
~/Applications/appimaged-*.AppImage


###
# Generating ssh key
###
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -P ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

chsh -s $(which zsh)

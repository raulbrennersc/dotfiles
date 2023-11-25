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


echo "Installing NVM"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.nvm/nvm.sh

chsh -s $(which zsh)

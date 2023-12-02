#!/usr/bin/env bash

set -e
set -f

echo "Install zsh"
if ! command -v zsh &> /dev/null
then
    sudo apt install zsh -y
fi

zsh

sudo apt update
echo "Installing build-essential"
sudo apt install build-essential -y

echo  "Install nala"
if ! command -v nala &> /dev/null
then
    sudo apt install nala -y
fi

echo "Install curl"
if ! command -v curl &> /dev/null
then
    sudo nala install curl -y
fi

echo "Install unzip"
if ! command -v unzip &> /dev/null
then
    sudo nala install unzip -y
fi

echo "Install oh my zsh"
printf "\n🚀 Installing oh-my-zsh\n"
if [ -d "${HOME}/.oh-my-zsh" ]; then
  printf "oh-my-zsh is already installed\n"
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "Install powerlevel10k"
printf "\n🚀 Installing powerlevel10k\n"
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  printf "powerlevel10k is already installed\n"
else
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

echo "Copy dotfiles"
printf "\n🚀 Installing dotfiles\n"
mkdir -p ${HOME}/.config/
cp -r $(pwd)/dotfiles/nvim ${HOME}/.config
cp $(pwd)/dotfiles/zsh/.zshrc ${HOME}/.zshrc
cp $(pwd)/dotfiles/zsh/.zprofile ${HOME}/.zprofile
cp $(pwd)/dotfiles/zsh/.p10k.zsh ${HOME}/.p10k.zsh

echo "Installing NVM"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.nvm/nvm.sh

echo "Install Meslo NF"
wget -P ~/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
unzip ~/.fonts/Meslo.zip -d ~/.fonts/Meslo
rm -rf ~/.fonts/Meslo.zip

# mkdir -p ~/Applications
# echo "Install Hyper terminal"
# curl https://releases.hyper.is/download/AppImage -o ~/Applications/hyper.AppImage

# echo "Installing appimaged"
# sudo nala install desktop-file-utils
# wget -c https://github.com/$(wget -q https://github.com/probonopd/go-appimage/releases/expanded_assets/continuous -O - | grep "appimaged-.*-x86_64.AppImage" | head -n 1 | cut -d '"' -f 2) -P ~/Applications/
# chmod +x ~/Applications/appimaged-*.AppImage

# Launch
# ~/Applications/appimaged-*.AppImage

echo "Install Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ${HOME}/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo "Install nvim"
brew install nvim

echo "Install ripgrep (used by nvim)"
brew install ripgrep

echo "Generating ssh keys"
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -P ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

chsh -s $(which zsh)
sudo reboot
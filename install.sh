#!/usr/bin/env bash

set -e
set -f

echo "Copy dotfiles"
printf "\n🚀 Installing dotfiles\n"
mkdir -p ${HOME}/.config/
cp -r $(pwd)/dotfiles/nvim ${HOME}/.config
cp $(pwd)/dotfiles/zsh/.zshrc ${HOME}/.zshrc

echo "Generating ssh keys"
if ! [ -f "${HOME}/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_ed25519 -q -P ""
  eval "$(ssh-agent -s)"
  ssh-add ${HOME}/.ssh/id_ed25519
fi

echo "Installing build-essential"
sudo apt install build-essential -y

echo  "Install nala"
if ! command -v nala &> /dev/null
then
    sudo apt install nala -y
fi

echo  "Install zsh"
if ! command -v zsh &> /dev/null
then
    sudo nala install zsh -y
fi

echo "Install Homebrew"
if ! [ -d "/home/linuxbrew/" ]; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
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
if ! [ -d "${HOME}/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "Install nvm"
if ! command -v nvm &> /dev/null
then
  PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash'
fi
echo "Install Meslo NF"
if ! [ -d "${HOME}/.fonts/Meslo" ]; then
  wget -P ${HOME}/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
  unzip ${HOME}/.fonts/Meslo.zip -d ${HOME}/.fonts/Meslo
  rm -rf ${HOME}/.fonts/Meslo.zip
fi

echo "Install ripgrep (used by nvim)"
if ! command -v ripgrep &> /dev/null
then
  brew install ripgrep
fi

echo "Install nvim"
if ! command -v nvim &> /dev/null
then
  brew install nvim
  nvim --headless +qa
  nvim --headless "+Lazy! sync" +qa
fi

echo "Install docker ce"
if ! command -v docker &> /dev/null
then
  curl -fsSL https://get.docker.com -o- | sh
fi

chsh -s $(which zsh)
sudo reboot
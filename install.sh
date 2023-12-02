#!/usr/bin/env zsh

set -e
set -f

echo "Copy dotfiles"
printf "\n🚀 Installing dotfiles\n"
mkdir -p ${HOME}/.config/
cp -r $(pwd)/dotfiles/nvim ${HOME}/.config
cp $(pwd)/dotfiles/zsh/.zshrc ${HOME}/.zshrc

echo "Installing build-essential"
sudo apt install build-essential -y

echo  "Install nala"
if ! command -v nala &> /dev/null
then
    sudo apt install nala -y
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

echo "Installing NVM"
PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash'
source ${HOME}/.nvm/nvm.sh

echo "Install Meslo NF"
if ! [ -d "${HOME}/.fonts/Meslo" ]; then
  wget -P ${HOME}/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
  unzip ${HOME}/.fonts/Meslo.zip -d ${HOME}/.fonts/Meslo
  rm -rf ${HOME}/.fonts/Meslo.zip
fi

echo "Install ripgrep (used by nvim)"
sudo nala install ripgrep -y

echo "Install nvim"
sudo nala install neovim -y
nvim --headless "+Lazy! sync" +qa

echo "Install docker ce"
curl -fsSL https://get.docker.com -o- | sh

echo "Generating ssh keys"
ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_ed25519 -q -P ""
eval "$(ssh-agent -s)"
ssh-add ${HOME}/.ssh/id_ed25519

chsh -s $(which zsh)
sudo reboot
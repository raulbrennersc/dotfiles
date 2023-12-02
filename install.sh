#!/usr/bin/env bash

set -e
set -f

NO_REBOOT=0
while [ $# -gt 0 ]; do
	case "$1" in
		--no-reboot)
			NO_REBOOT=1
			;;
	esac
	shift $(( $# > 0 ? 1 : 0 ))
done

echo "Copy dotfiles"
printf "\n🚀 Installing dotfiles\n"
mkdir -p ${HOME}/.config/
cp -r $(pwd)/dotfiles/nvim ${HOME}/.config
cp $(pwd)/dotfiles/zsh/.zshrc ${HOME}/.zshrc

if ! [ -f "${HOME}/.ssh/id_ed25519" ]; then
  echo "Generating ssh keys"
  ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_ed25519 -q -P ""
  eval "$(ssh-agent -s)"
  ssh-add ${HOME}/.ssh/id_ed25519
fi

echo "Installing build-essential"
sudo apt install build-essential -y

if ! command -v nala &> /dev/null; then
  echo  "Install nala"
  sudo apt install nala -y
fi

if ! command -v zsh &> /dev/null; then
  echo  "Install zsh"
    sudo nala install zsh -y
fi

if ! command -v curl &> /dev/null; then
echo "Install curl"
    sudo nala install curl -y
fi

if ! [ -d "/home/linuxbrew/" ]; then
  echo "Install Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if ! command -v unzip &> /dev/null; then
echo "Install unzip"
    sudo nala install unzip -y
fi

if ! [ -d "${HOME}/.oh-my-zsh" ]; then
  echo "Install oh my zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if ! command -v nvm &> /dev/null; then
  echo "Install nvm"
  PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash'
  source ~/.nvm/nvm.sh
fi

if ! [ -d "${HOME}/.fonts/Meslo" ]; then
  echo "Install Meslo NF"
  wget -P ${HOME}/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
  unzip ${HOME}/.fonts/Meslo.zip -d ${HOME}/.fonts/Meslo
  rm -rf ${HOME}/.fonts/Meslo.zip
fi

if ! command -v ripgrep &> /dev/null; then
  echo "Install ripgrep (used by nvim)"
  brew install ripgrep
fi

if ! command -v nvim &> /dev/null; then
  echo "Install nvim"
  brew install nvim
  nvim --headless +qa
  nvim --headless "+Lazy! sync" +qa
fi

if ! command -v oh-my-posh &> /dev/null; then
  echo "Install oh-my-posh"
  brew install jandedobbeleer/oh-my-posh/oh-my-posh
fi

if ! command -v docker &> /dev/null; then
  echo "Install docker ce"
  curl -fsSL https://get.docker.com -o- | sh
fi

chsh -s $(which zsh)

if ! [ -z "$NO_REBOOT" ]; then
  sudo reboot
fi
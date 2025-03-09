#!/bin/bash
export XDG_CONFIG_HOME="$HOME"/.config
export DEBIAN_FRONTEND=noninteractive

sudo apt update
sudo apt install zsh git -y

if ! [ -d "~/dotfiles" ]; then
  git clone https://github.com/raulbrennersc/dotfiles.git ~/dotfiles
  cd ~/dotfiles
  git remote set-url origin git@github.com:raulbrennersc/dotfiles.git
  cd
fi

mkdir -p ${HOME}/.config
ln -s ${HOME}/dotfiles/.config/nvim ${HOME}/.config/nvim

rm -rf ${HOME}/.zshrc
rm -rf ${HOME}/.gitconfig
rm -rf ${HOME}/.tmux.conf

ln -s ${HOME}/dotfiles/.gitconfig ${HOME}/.gitconfig
ln -s ${HOME}/dotfiles/.tmux.conf ${HOME}/.tmux.conf

if ! [ -d "/home/linuxbrew/" ]; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

if [ -d "/workspaces" ]; then
  ln -s /workspaces ${HOME}/workspaces
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
brew install fzf ripgrep neovim tmux jandedobbeleer/oh-my-posh/oh-my-posh
rm -rf ${HOME}/.zshrc
ln -s ${HOME}/dotfiles/.zshrc ${HOME}/.zshrc

sudo chsh -s $(which zsh) $(whoami)

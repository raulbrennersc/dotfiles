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

mkdir -p ~/.config
ln -s ~/dotfiles/.config/nvim ~/.config/nvim

rm -rf ~/.zshrc
rm -rf ~/.gitconfig
rm -rf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

if ! [ -d "/home/linuxbrew/" ]; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

if [ -d "/workspaces" ]; then
  ln -s /workspaces ~/workspaces
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
brew install fzf ripgrep neovim tmux jandedobbeleer/oh-my-posh/oh-my-posh
rm -rf ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc

sudo chsh -s $(which zsh) $(whoami)

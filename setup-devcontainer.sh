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

wget https://github.com/wezterm/wezterm/releases/download/nightly/wezterm-nightly.Debian12.deb -O wezterm.deb
sudo apt install ./wezterm.deb -y

echo "sudo chown -R ${USER}:${USER} /var/run/docker.sock" >>.zprofile

mkdir -p ~/.config
ln -s ~/dotfiles/.config/nvim ~/.config/nvim

rm -rf ~/.gitconfig
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
mkdir -p ~/.docker
cp ~/dotfiles/.docker/config.json ~/.docker/config.json

if ! [ -d "/home/linuxbrew/" ]; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

if [ -d "/workspaces" ]; then
  ln -s /workspaces ~/workspaces
fi

curl -L http://install.ohmyz.sh | sh
curl -s https://ohmyposh.dev/install.sh | bash -s
brew install fzf ripgrep neovim
rm -rf ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc

sudo chsh -s $(which zsh) $(whoami)

#!/bin/bash
export XDG_CONFIG_HOME="$HOME"/.config
export DEBIAN_FRONTEND=noninteractive

curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
sudo apt update
sudo apt install zsh git ripgrep fd-find tmux wezterm-nightly -y

if ! [ -d "~/dotfiles" ]; then
  git clone https://github.com/raulbrennersc/dotfiles.git ~/dotfiles
  cd ~/dotfiles
  git remote set-url origin git@github.com:raulbrennersc/dotfiles.git
  cd
fi

mkdir -p ~/.config
ln -s ~/dotfiles/.config/nvim ~/.config/nvim

ln -s ~/dotfiles/.config/git/config ~/.config/git/config
ln -s ~/dotfiles/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf
mkdir -p ~/.docker
cp ~/dotfiles/.docker/config.json ~/.docker/config.json

if ! [ -d "/home/linuxbrew/" ]; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

if [ -d "/workspaces" ]; then
  ln -s /workspaces ~/workspaces
fi

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm -rf nvim-linux-x86_64.tar.gz

curl -L http://install.ohmyz.sh | sh
curl -s https://ohmyposh.dev/install.sh | bash -s
rm -rf ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc

sudo chsh -s $(which zsh) $(whoami)

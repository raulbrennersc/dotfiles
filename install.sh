#!/bin/bash

set -e
set -f

export DEBIAN_FRONTEND=noninteractive

if command -v apt 2>&1 >/dev/null; then
  wget -O- raulbrennersc.dev/dotfiles/install-debian.sh | bash -s
elif command -v pacman 2>&1 >/dev/null; then
  wget -O- raulbrennersc.dev/dotfiles/install-arch.sh | bash -s
fi

if ! [ -d "~/dotfiles" ]; then
  echo "Clone dotfiles"
  git clone https://github.com/raulbrennersc/dotfiles.git ~/dotfiles
  cd ~/dotfiles
  git remote set-url origin git@github.com:raulbrennersc/dotfiles.git
  cd
fi

echo "Generate ssh keys and config"
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -P ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

echo "Create symlinks to dotfiles"
mkdir -p ~/.config/autostart ~/.config/dconf ~/.config/environment.d ~/.config/git ~/.config/tmux ~/.config/fastfetch ~/.docker/
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dotfiles/.config/git/config ~/.config/git/config
ln -s ~/dotfiles/.config/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
ln -s ~/dotfiles/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -s ~/dotfiles/.config/wezterm ~/.config/wezterm
ln -s ~/dotfiles/.config/alacritty ~/.config/alacritty
ln -s ~/dotfiles/.config/solaar ~/.config/solaar
ln -s ~/dotfiles/.config/cava ~/.config/cava
ln -s ~/dotfiles/.config/dconf/user.d ~/.config/dconf/user.d
cp ~/dotfiles/.config/environment.d/mangohud.conf ~/.config/environment.d/mangohud.conf
cp ~/dotfiles/.docker/config.json ~/.docker/config.json
cp ~/dotfiles/.config/autostart/solaar.desktop ~/.config/autostart/solaar.desktop
cp ~/dotfiles/.config/autostart/startup.desktop ~/.config/autostart/startup.desktop
cp ~/dotfiles/.ssh/config ~/.ssh/config
sudo ln -s ~/dotfiles/scripts/devcontainers.sh /usr/bin/devcontainer

echo "Enable flathub"
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Install flatpaks"
flatpak install -y app.zen_browser.zen re.sonny.Junction com.rtosta.zapzap

echo "Set default browser"
xdg-settings set default-web-browser re.sonny.Junction.desktop

echo "Install Postman"
curl -L -o postman.tar.gz https://dl.pstmn.io/download/latest/linux_64
mkdir ~/Applications/
tar xzvf postman.tar.gz -C Applications/
sudo ln -s ~/Applications/Postman/Postman /usr/bin/postman
sudo cp ~/dotfiles/.config/applications/postman.desktop /usr/share/applications/postman.desktop
rm -rf postman.tar.gz

echo "Install Hack Nerd Font"
wget -P ~/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip
unzip ~/.fonts/Hack.zip -d ~/.fonts/Hack
rm -rf ~/.fonts/Hack.zip

echo "Apply GNOME customization"
dconf compile ~/.config/dconf/user ~/.config/dconf/user.d
sudo dconf update

echo "Install oh-my-zsh"
curl -L http://install.ohmyz.sh | sh

echo "Install oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | bash -s

rm -rf ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.zprofile ~/.zprofile

sudo chsh -s $(which zsh) $(whoami)

sudo usermod -aG docker $USER
newgrp docker

sudo systemctl enable systemd-resolved.service
sudo systemctl enable docker.socket
sudo systemctl enable docker.service
systemctl --user enable gcr-ssh-agent.socket

sudo reboot

!#/bin/bash

set -e
set -f

if command -v apt 2>&1 >/dev/null; then
  wget -O- raulbrennersc/dotfiles/install-debian.sh | bash -s
elif command -v pacman 2>&1 >/dev/null; then
  wget -O- raulbrennersc/dotfiles/install-arch.sh | bash -s
fi

if ! [ -d "~/dotfiles" ]; then
  echo "Clone dotfiles"
  git clone -b debian https://github.com/raulbrennersc/dotfiles.git ~/dotfiles
  cd ~/dotfiles
  git remote set-url origin git@github.com:raulbrennersc/dotfiles.git
  cd
fi

echo "Generate ssh keys and config"
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -P ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

echo "Create symlinks to dotfiles"
mkdir -p ~/.config/dconf
mkdir -p ~/.config/autostart
mkdir -p ~/.config/environment.d
mkdir -p ~/.docker/
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.config/wezterm ~/.config/wezterm
ln -s ~/dotfiles/.config/solaar ~/.config/solaar
ln -s ~/dotfiles/.config/cava ~/.config/cava
ln -s ~/dotfiles/.config/dconf/user.d ~/.config/dconf/user.d
cp ~/dotfiles/.config/environment.d/mangohud.conf ~/.config/environment.d/mangohud.conf
cp ~/dotfiles/.docker/config.json ~/.docker/config.json
cp ~/dotfiles/.config/autostart/solaar.desktop ~/.config/solaar.desktop
cp ~/dotfiles/.ssh/config ~/.ssh/config
sudo ln -s ~/dotfiles/scripts/devcontainers.sh /usr/bin/devcontainer

echo "Enable flathub"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Install flatpaks"
flatpak install -y app.zen_browser.zen io.dbeaver.DBeaverCommunity com.mattjakeman.ExtensionManager

echo "Install Postman"
curl -L -o postman.tar.gz https://dl.pstmn.io/download/latest/linux_64
mkdir ~/Applications/
tar xzvf postman.tar.gz -C Applications/
sudo ln -s ~/Applications/Postman/Postman /usr/bin/postman
sudo cp ~/dotfiles/.config/applications/postman.desktop /usr/share/applications/postman.desktop
rm -rf postman.tar.gz

echo "Install JetBrainsMono NF"
wget -P ~/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip ~/.fonts/JetBrainsMono.zip -d ~/.fonts/JetBrainsMono
rm -rf ~/.fonts/JetBrainsMono.zip

echo "Apply GNOME customization"
dconf compile ~/.config/dconf/user ~/.config/dconf/user.d
sudo dconf update

sudo chsh $USER -s /usr/bin/zsh

echo "Install oh-my-zsh"
curl -L http://install.ohmyz.sh | sh

echo "Install oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | bash -s

rm -rf ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.zprofile ~/.zprofile

sudo usermod -aG docker $USER
newgrp docker

sudo systemctl enable systemd-resolved.service
sudo systemctl enable docker.socket
sudo systemctl enable docker.service
systemctl --user enable gcr-ssh-agent.socket

sudo reboot

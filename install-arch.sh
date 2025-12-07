#!/bin/bash

echo "Install packages"
sudo pacman -Syu --needed base-devel git flatpak curl openssh ddcutil \
  unzip cmatrix fd solaar fastfetch cava zsh networkmanager-openvpn tmux \
  vim fuse2 fuse3 qbittorrent chromium alacritty libnma-gtk4 ripgrep vlc \
  gnome-shell-extension-appindicator gnome-shell-extension-vitals neovim \
  docker docker-compose firefox papirus-icon-theme dbeaver xclip sqlite \
  spotify-launcher

sudo systemctl restart systemd-resolved.service

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd
yay wezterm-nightly-bin

if ! [ -d "~/dotfiles" ]; then
  echo "Clone dotfiles"
  git clone https://github.com/raulbrennersc/dotfiles.git ~/dotfiles
fi
cd ~/dotfiles
git remote set-url origin git@github.com:raulbrennersc/dotfiles.git
cd

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
cp ~/dotfiles/.docker/config.json ~/.docker/config.json
cp ~/dotfiles/.config/autostart/solaar.desktop ~/.config/autostart/solaar.desktop
cp ~/dotfiles/.config/autostart/startup.desktop ~/.config/autostart/startup.desktop
cp ~/dotfiles/.ssh/config ~/.ssh/config
# ln -s ~/dotfiles/.config/MangoHud ~/.config/MangoHud
# cp ~/dotfiles/.config/environment.d/mangohud.conf ~/.config/environment.d/mangohud.conf
sudo ln -s ~/dotfiles/scripts/devcontainer.sh /usr/bin/devcontainer

echo "Enable flathub"
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Install flatpaksinstal"
flatpak install flathub com.belmoussaoui.Authenticator -y --noninteractive
flatpak install flathub com.mattjakeman.ExtensionManager -y --noninteractive
flatpak install flathub com.usebruno.Bruno -y --noninteractive
flatpak install flathub org.mozilla.firefox -y --noninteractive

echo "Install Hack Nerd Font"
wget -P ~/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip
unzip ~/.fonts/Hack.zip -d ~/.fonts/Hack
rm -rf ~/.fonts/Hack.zip

echo "Apply GNOME customization"
dconf compile ~/.config/dconf/user ~/.config/dconf/user.d
sudo dconf update

# echo "Set default browser"
# xdg-settings set default-web-browser /var/lib/flatpak/exports/share/applications/re.sonny.Junction.desktop

echo "Install oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | bash -s

echo "Install oh-my-zsh"
curl -L http://install.ohmyz.sh | sh

sudo chsh -s $(which zsh) $(whoami)
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

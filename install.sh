!/bin/bash

echo "Install packages"
sudo pacman -Syu --needed git base-devel
sudo pacman -Syu flatpak curl openssh ddcutil unzip cmatrix fd fastfetch \
  cava tmux vim qbittorrent chromium alacritty ripgrep vlc neovim docker \
  docker-compose firefox dbeaver sqlite spotify-launcher steam stylua \
  lua-language-server hyprland waybar nautilus mako sddm ttf-jetbrains-mono-nerd \
  swayosd xdg-desktop-portal-hyprland xdg-desktop-portal-gtk uwsm swaybg \
  ddcutil bluetui firefox libnewt hyprlock hypridle impala less polkit-gnome \
  gnome-disk-utility bash-completion hyprpicker grim slurp hyprshot \
  gpu-screen-recorder power-profiles-daemon fzf fd wl-clipboard ffmpeg \
  chromium brightnessctl pulsemixer networkmanager noto-fonts-emoji


sudo systemctl restart systemd-resolved.service
sudo modprobe i2c-dev
sudo systemctl enable sddm
sudo systemctl enable --now power-profiles-daemon
sudo systemctl enable --now NetworkManager

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd
yay -Syu walker elephant elephant-desktopapplications elephant-clipboard \
elephant-calc elephant-clipboard elephant-bluetooth elephant-desktopapplications \
elephant-files elephant-menus elephant-providerlist elephant-runner elephant-symbols \
elephant-unicode elephant-websearch elephant-todo 


elephant service enable
systemctl --user start elephant.service
sudo systemctl start swayosd-libinput-backend.service

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
mkdir -p ~/.config/ ~/.docker/ ~/.local/bin
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
ln -s ~/dotfiles/.config/hypr ~/.config/hypr
ln -s ~/dotfiles/.config/waybar ~/.config/waybar
ln -s ~/dotfiles/.config/git ~/.config/git
ln -s ~/dotfiles/.config/fastfetch ~/.config/fastfetch
ln -s ~/dotfiles/.config/tmux ~/.config/tmux
ln -s ~/dotfiles/.config/wezterm ~/.config/wezterm
ln -s ~/dotfiles/.config/alacritty ~/.config/alacritty
ln -s ~/dotfiles/.config/cava ~/.config/cava
ln -s ~/dotfiles/.config/walker ~/.config/walker
ln -s ~/dotfiles/.config/elephant ~/.config/elephant
ln -s ~/dotfiles/.config/mako ~/.config/mako
ln -s ~/dotfiles/.docker ~/.docker
ln -s ~/dotfiles/.config/ghostty ~/.config/ghostty

ln -s ~/dotfiles/.config/autostart ~/.config/autostart

ln -s ~/dotfiles/scripts ~/.local/bin/scripts

ln -s ~/dotfiles/.desktop/tui-bluetooth.desktop ~/.local/share/applications/tui-bluetooth.desktop
ln -s ~/dotfiles/.desktop/tui-wifi.desktop ~/.local/share/applications/tui-wifi.desktop
cp ~/dotfiles/.ssh/config ~/.ssh/config

echo "Install oh-my-posh"
curl -s https://ohmyposh.dev/install.sh | bash -s

rm -rf ~/.bashrc
ln -s ~/dotfiles/.bashrc ~/.bashrc

sudo usermod -aG docker $USER
newgrp docker

sudo systemctl enable systemd-resolved.service
sudo systemctl enable docker.socket
sudo systemctl enable docker.service

sudo reboot


#!/bin/bash

set -e
set -f

DOTFILES_USER=${USER}

echo "## Remainder to install extras ##"
echo "### Papirus Icon"
echo "### Volantes Cursor"


echo "Create symlinks for dotfiles"
mkdir -p ${HOME}/.config
mkdir -p ${HOME}/.var/app/com.vscodium.codium/config/VSCodium/User/
ln -s ${HOME}/dotfiles/.config/solaar ${HOME}/.config/solaar
ln -s ${HOME}/dotfiles/.config/nvim ${HOME}/.config/nvim
ln -s ${HOME}/dotfiles/.config/vscodium/settings.json ${HOME}/.config/VSCodium/User/settings.json
ln -s ${HOME}/dotfiles/.zshrc ${HOME}/.zshrc
ln -s ${HOME}/dotfiles/.gitconfig ${HOME}/.gitconfig
ln -s ${HOME}/dotfiles/.tmux.conf ${HOME}/dotfiles/.tmux.conf

echo "Generate ssh keys"
ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_ed25519 -q -P ""
eval "$(ssh-agent -s)"
ssh-add ${HOME}/.ssh/id_ed25519

if command -v dnf &> /dev/null;
then
  echo "Install Fedora packages"
  sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
  printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h\n" | sudo tee -a /etc/yum.repos.d/vscodium.repo
  sudo dnf install flatpak solaar codium tmux zsh -y
  sudo dnf install @development-tools -y
elif command -v apt &> /dev/null;
then
  echo "Install Debian packages"
  wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
  echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
  sudo apt update
  sudo apt install build-essential flatpak solaar codium tmux zsh -y
fi

echo "Enable Solaar"
sudo setfacl -m u:${DOTFILES_USER}:rw /dev/uinput

echo "Enable flathub"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Install Zen"
flatpak install app.zen_browser.zen -y

echo "Creating Zen Profile"
flatpak run app.zen_browser.zen -CreateProfile $DOTFILES_USER

local folder=$(sed -n "/Path=.*\.${DOTFILES_USER}$/ s/.*=//p" ~/.var/app/app.zen_browser.zen/.zen/profiles.ini)
local zenpath="/home/${DOTFILES_USER}/.var/app/app.zen_browser.zen/.zen/$folder"

ln -s ${HOME}/dotfiles/.config/zen/user.js ${zenpath}/user.js

echo "Downloading Zen Addons"

mozillaurl="https://addons.mozilla.org"
addontmp=$(mktemp -d)
mkdir -p "$zenpath/extensions/"
extension_list=$(grep -oP '"addons_list":\s*\[\K[^\]]+' ${HOME}/dotfiles/.config/zen/config.json | tr -d ' ",')

IFS=','
for addon in $addons_list; do
  addon=$(echo "$addon" | tr -d ' ')

  echo "Installing $addon"
  addonurl=$(curl --silent "$mozillaurl/en-US/firefox/addon/$addon/" | grep -o "$mozillaurl/firefox/downloads/file/[^\"]*")
  file="${addonurl##*/}"

  curl -LOs "$addonurl" > "$addontmp/$file"

  id=$(unzip -p "$addontmp/$file" manifest.json | grep -o '"id": *"[^"]*' | sed 's/"id": *"//')

  mv "$addontmp/$file" "$path/extensions/$id.xpi"
done
rm -fr $addontmp

echo "Install codium extensions"
while read p; do
  codium --install-extension "$p"
done < ${HOME}/dotfiles/.config/vscodium/extensions

echo "Install homebrew"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

mkdir -p ${HOME}/.fonts
echo "Install Meslo Nerd Font"
wget -P ${HOME}/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip
unzip ${HOME}/.fonts/Meslo.zip -d ${HOME}/.fonts/Meslo
rm -rf ${HOME}/.fonts/Meslo.zip

echo "Install FiraCode Nerd Font"
wget -P ${HOME}/.fonts/ https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip ${HOME}/.fonts/FiraCode.zip -d ${HOME}/.fonts/FiraCode
rm -rf ${HOME}/.fonts/FiraCode.zip

sudo chsh $DOTFILES_USER -s $(which zsh)

echo "Install oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Install oh-my-posh"
brew install jandedobbeleer/oh-my-posh/oh-my-posh

rm -rf ${HOME}/.zshrc
ln -s ${HOME}/dotfiles/.zshrc ${HOME}/.zshrc

echo "Install docker ce"
curl -fsSL https://get.docker.com -o- | sh
sudo groupadd docker
sudo usermod -aG docker $DOTFILES_USER
newgrp docker

sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service
sudo systemctl enable --now sshd

echo "Install DevPod"
curl -L -o devpod "https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64" && sudo install -c -m 0755 devpod /usr/local/bin && rm -f devpod

sudo reboot

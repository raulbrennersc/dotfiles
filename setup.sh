!#/bin/bash

if ! [ -d "~/dotfiles" ]; then
  echo "Clone dotfiles"
  wget https://github.com/raulbrennersc/dotfiles/archive/debian.zip
  unzip debian.zip
  mv dotfiles-debian dotfiles
fi
~/dotfiles/scripts/install-packages.sh
if ! [ -d "~/dotfiles/.git" ]; then
  cd ~/dotfiles
  git init
  git remote add origin https://github.com/raulbrennersc/dotfiles.git
  git clean -fd
  git pull origin main
  git remote set-url origin git@github.com:raulbrennersc/dotfiles.git
fi
sudo reboot

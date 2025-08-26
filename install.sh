#!/bin/bash

set -e
set -f

export DEBIAN_FRONTEND=noninteractive

if command -v apt 2>&1 >/dev/null; then
  wget -O- raulbrennersc.dev/dotfiles/install-debian.sh | bash -s
elif command -v pacman 2>&1 >/dev/null; then
  wget -O- raulbrennersc.dev/dotfiles/install-arch.sh | bash -s
fi

export ZSH=$HOME/.oh-my-zsh

bindkey '^H' backward-kill-word

plugins=(git gcloud nvm docker)

source $ZSH/oh-my-zsh.sh


if command -v oh-my-posh &> /dev/null; then
  eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/catppuccin_mocha.omp.json')"
fi

if [ -d "/home/linuxbrew/" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

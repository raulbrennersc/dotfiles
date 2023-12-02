export ZSH=$HOME/.oh-my-zsh

bindkey '^H' backward-kill-word

plugins=(git gcloud nvm docker)

source $ZSH/oh-my-zsh.sh

if [ -d "/home/linuxbrew/" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  eval "$(oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/catppuccin_mocha.omp.json)"
fi

export ZSH=$HOME/.oh-my-zsh

bindkey '^H' backward-kill-word

plugins=(git gcloud nvm docker)

if [ -d "/home/linuxbrew/" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if command -v oh-my-posh &> /dev/null; then
  eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/gruvbox.omp.json')"
fi


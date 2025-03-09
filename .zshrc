export ZSH=$HOME/.oh-my-zsh
export PATH=$PATH:$HOME/.local/bin
export XDG_CONFIG_HOME=$HOME/.config
export DEVCONTAINER_IMAGE=raulbrennersc/devcontainer:latest
export DEVCONTAINER_SETUP_SCRIPT_URL=https://raw.githubusercontent.com/raulbrennersc/dotfiles/refs/heads/main/setup-devcontainer.sh
source $ZSH/oh-my-zsh.sh

alias vim="nvim"
alias vi="nvim"
alias tmux="tmux new-session -A -s"
alias gca="git add -A && git commit -m"
alias gc="git commit -m"
alias gs="git status"

devcontainerUp() {
  docker run -d --privileged --name $1 --mount type=bind,src=/tmp/.X11-unix,dst=/tmp/.X11-unix --network=host --volume $SSH_AUTH_SOCK:/ssh-agent --env SSH_AUTH_SOCK=/ssh-agent $DEVCONTAINER_IMAGE
  docker exec -it $1 bash -c "curl -s $DEVCONTAINER_SETUP_SCRIPT_URL | bash -s"
  docker exec -it $1 zsh
}

devcontainerExec() {
  docker exec -it $1 zsh
}

zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -e

plugins=(git gcloud nvm brew docker)

bindkey '^H' backward-kill-word

if [ -d "/home/linuxbrew/" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if command -v oh-my-posh &> /dev/null; then
  eval "$(oh-my-posh init zsh --config ~/dotfiles/.config/oh-my-posh/theme.omp.json)"
fi

if [ -d "$HOME/.nvm/" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

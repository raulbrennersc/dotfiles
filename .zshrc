export ZSH=$HOME/.oh-my-zsh
export PATH=$PATH:$HOME/.local/bin
export XDG_CONFIG_HOME=$HOME/.config
export DEVCONTAINER_IMAGE=raulbrennersc/devcontainer:latest
export DEVCONTAINER_SETUP_SCRIPT_URL=https://raw.githubusercontent.com/raulbrennersc/dotfiles/refs/heads/main/setup-devcontainer.sh
export CONTAINER_ENGINE=docker
source $ZSH/oh-my-zsh.sh

alias vim="nvim"
alias vi="nvim"
alias tmux="tmux new-session -A -s"
alias gca="git add -A && git commit -m"
alias gc="git commit -m"
alias gs="git status"

devcontainer() {
  case $1 in
    "up")
      devcontainerUp $@
      ;;

    "start")
      devcontainerStart $@
      ;;

    "stop")
      devcontainerStop $@
      ;;

    "rm")
      devcontainerRm $@
      ;;

    "exec")
      devcontainerExec $@
      ;;

    "ssh")
      devcontainerMux $@
      ;;

    *)
      echo "unrecognized option $1"
      ;;
  esac
}

getContainerName() {
  echo "${1}.devcontainer"
}

devcontainerUp() {
  x="cat ~/.ssh/id_ed25519.pub"
  KEY_TO_AUTHORIZE=$(eval "$x")
  containerName=$(getContainerName $2)
  echo $containerName

  $CONTAINER_ENGINE run -d --privileged --name $containerName --dns=127.0.0.53 \
    --volume /var/run/docker.sock:/var/run/docker.sock --network=host \
    --env CUSTOM_SSH_PORT=$3 --env KEY_TO_AUTHORIZE=$KEY_TO_AUTHORIZE $DEVCONTAINER_IMAGE
  $CONTAINER_ENGINE exec -it $containerName bash -c "curl -s $DEVCONTAINER_SETUP_SCRIPT_URL | bash -s"
}

devcontainerStart(){
  $CONTAINER_ENGINE start $(getContainerName $2)
}

devcontainerStop(){
  $CONTAINER_ENGINE stop $(getContainerName $2)
}

devcontainerRm(){
  $CONTAINER_ENGINE rm $(getContainerName $2)
}

devcontainerMux() {
  wezterm ssh $(getContainerName $2) & disown
}

devcontainerExec() {
  $CONTAINER_ENGINE exec -it $(getContainerName $2) bash
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

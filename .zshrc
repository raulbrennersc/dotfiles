export ZSH=$HOME/.oh-my-zsh
export PATH=$PATH:$HOME/.local/bin:/opt/nvim-linux-x86_64/bin
export XDG_CONFIG_HOME=$HOME/.config
source $ZSH/oh-my-zsh.sh
export CUSTOM_HOST=${DEVCONTAINER_NAME:-${HOST}}

alias vi="nvim"
alias tmux="tmux new-session -A -s $USER"

alias gb="git branch"
alias gca="git add -A && git commit -m"
alias gc="git commit -m"
alias gs="git status"
alias gd="git diff"
alias gp="git push"
alias gu="git pull"
alias gl="git log"

alias sqlite=sqlite3

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

if command -v oh-my-posh &> /dev/null; then
  eval "$(oh-my-posh init zsh --config ~/dotfiles/.config/oh-my-posh/custom.omp.toml)"
fi

if [ -d "$HOME/.nvm/" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi


# if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then
#   tmux
# fi

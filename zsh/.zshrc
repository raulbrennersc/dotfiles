export ZSH=$HOME/.oh-my-zsh
export PATH=$PATH:$HOME/.local/bin

# sudo setfacl -m u:${USER}:rw /dev/uinput

bindkey '^H' backward-kill-word

if [ -d "/home/linuxbrew/" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if command -v oh-my-posh &> /dev/null; then
  eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/gruvbox.omp.json')"
fi


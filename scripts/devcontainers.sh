#!/bin/bash

DEVCONTAINER_IMAGE=raulbrennersc/devcontainer:latest
DEVCONTAINER_SETUP_SCRIPT_URL=https://raw.githubusercontent.com/raulbrennersc/dotfiles/refs/heads/main/setup-devcontainer.sh
CONTAINER_ENGINE=docker
DEVCONTAINERS_CONFIG_DIR=~/.config/devcontainers/
DEVCONTAINERS_DB_FILE_NAME=devcontainers.db
DEVCONTAINERS_DB_FILE_PATH=$DEVCONTAINERS_CONFIG_DIR/$DEVCONTAINERS_DB_FILE_NAME
DEVCONTAINER_USER=dev

devcontainer() {
  case $1 in
  "up")
    devcontainer_up $2
    ;;

  "start")
    devcontainer_start $2
    ;;

  "stop")
    devcontainer_stop $2
    ;;

  "rm")
    devcontainer_rm $2
    ;;

  "exec")
    devcontainer_exec $2
    ;;

  "proxy")
    devcontainer_proxy $2
    ;;

  "list")
    devcontainer_list $2
    ;;

  "connect")
    devcontainer_connect $2
    ;;

  "test")
    devcontainer_test $@
    ;;

  *)
    echo "unrecognized option $1"
    ;;
  esac
}

devcontainer_test() {
  echo "test"
}

check_and_setup() {
  if ! [ -d $DEVCONTAINERS_CONFIG_DIR ]; then
    mkdir -p $DEVCONTAINERS_CONFIG_DIR
  fi

  if ! [ -f $DEVCONTAINERS_DB_FILE_PATH ]; then
    echo "create table devcontainers (name text not null, port int unique not null, engine text not null, UNIQUE (name, engine));" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH
  fi

  if ! [ -f ~/.ssh/config ]; then
    touch ~/.ssh/config
  fi

  local content=$(cat ~/.ssh/config | grep 'Host \*.devcontainer')
  if [ "$content" = "" ]; then
    echo -e "\nHost *.devcontainer\n  User dev\n  ProxyCommand devcontainer proxy %h\n" >>~/.ssh/config
  fi
}

build_container_name() {
  echo "${1}.devcontainer"
}

get_next_available_port() {
  IN=$(echo "select port from devcontainers;" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH)
  local ports=(${IN// /})
  declare -i port=2222
  while [[ true ]]; do
    if [[ " ${ports[*]} " =~ [[:space:]]${port}[[:space:]] ]]; then
      port=$port+1
    else
      break
    fi
  done
  echo $port
}

check_name_exists() {
  IN=$(echo "select name from devcontainers d where d.engine='$CONTAINER_ENGINE' and d.name='$1';" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH)
  if ! [ -n "$IN" ]; then
    echo "error: a devcontiner with name $1 already exists"
    exit 1
  fi
}

devcontainer_up() {
  local available_port=$(get_next_available_port)
  check_name_exists $1
  local key_to_authorize="$(cat ~/.ssh/id_ed25519.pub)"
  local container_name=$(build_container_name $1)

  mkdir -p ~/workspaces/$1
  echo "Creating devcontainer $container_name"
  $CONTAINER_ENGINE run -d --privileged --name $container_name \
    --volume /home/$USER/workspaces/$1:/workspaces --volume /var/run/docker.sock:/var/run/docker.sock \
    --network=host --restart=always --dns=127.0.0.53 \
    --env CUSTOM_SSH_PORT=$available_port --env KEY_TO_AUTHORIZE="$key_to_authorize" --env DEVCONTAINER_NAME="$1" \
    $DEVCONTAINER_IMAGE

  echo "Updating devcontainers db entries"
  echo "insert into devcontainers (name, port, engine) VALUES ('$container_name', '$available_port', '$CONTAINER_ENGINE');" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH

  echo "Running setup script"
  $CONTAINER_ENGINE exec -it $container_name bash -c "curl -s $DEVCONTAINER_SETUP_SCRIPT_URL | bash -s"
}

devcontainer_start() {
  $CONTAINER_ENGINE start $(build_container_name $1)
}

devcontainer_stop() {
  $CONTAINER_ENGINE stop $(build_container_name $1)
}

devcontainer_rm() {
  local container_name=$(build_container_name $1)
  local name=$(echo "select name from devcontainers d where d.name='$container_name' and d.engine='$CONTAINER_ENGINE';" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH)
  if [[ "$name" = "" ]]; then
    echo "Devcontainer $1 not found. If you created it directly through $CONTAINER_ENGINE use the command '$CONTAINER_ENGINE rm $1' to remove it."
    exit 1
  fi
  devcontainer_stop $1
  $CONTAINER_ENGINE rm $(build_container_name $1)
  echo "delete from devcontainers where name='$container_name' and engine='$CONTAINER_ENGINE';" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH
}

devcontainer_exec() {
  devcontainer_start $1
  $CONTAINER_ENGINE exec -it $(build_container_name $1) bash
}

devcontainer_port() {
  local port=$(echo "select port from devcontainers d where d.name='$1' and d.engine='$CONTAINER_ENGINE';" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH)
  echo $port
}

devcontainer_proxy() {
  local port=$(devcontainer_port $1)
  ssh -YA -W localhost:$port dev@localhost -p "$port"
}

devcontainer_ssh() {
  local port=$(devcontainer_port $1)
  ssh -YA -o User=$DEVCONTAINER_USER dev@localhost -p "$port"
}

devcontainer_list() {
  local names=$(echo "select name,port from devcontainers d where d.engine='$CONTAINER_ENGINE';" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH)
  echo $names
}

devcontainer_connect() {
  if ! [[ "$1" = "" ]]; then
    devcontainer_ssh $(build_container_name $1)
    exit 0
  fi
  local names=$(echo "select name from devcontainers d where d.engine='$CONTAINER_ENGINE';" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH)
  PS3="Select the devcontainer to connect: "
  names=(${names// /})
  select devcontainer in "${names[@]}" Quit; do
    if [ "$devcontainer" = "" ]; then
      echo "Invalid option $REPLY"
      exit 1
    fi

    if [ "$devcontainer" = "Quit" ]; then
      exit 0
    fi

    devcontainer_ssh $devcontainer
    exit 0
  done
}

check_and_setup
devcontainer $@

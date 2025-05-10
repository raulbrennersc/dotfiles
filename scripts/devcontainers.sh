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

  "connect")
    devcontainer_connect
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
    echo "create table devcontainers (name text not null primary key, port int unique);" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH
  fi

  if ! [ -f ~/.ssh/config ]; then
    touch ~/.ssh/config
  fi

  content=$(cat ~/.ssh/config | grep 'Host \*.devcontainer')
  if [ "$content" = "" ]; then
    echo -e "\nHost *.devcontainer\n  User dev\n  ProxyCommand devcontainer proxy %h\n" >>~/.ssh/config
  fi
}

get_container_name() {
  echo "${1}.devcontainer"
}

get_avilable_port() {
  IN=$(echo "select port from devcontainers;" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH)
  ports=(${IN// /})
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
  IN=$(echo "select name from devcontainers;" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH)
  names=(${IN// /})
  if [[ " ${names[*]} " =~ [[:space:]]$1[[:space:]] ]]; then
    echo "error: a devcontiner with name $1 already exists"
    exit 1
  fi
}

devcontainer_up() {
  available_port=$(get_avilable_port)
  check_name_exists $1
  key_to_authorize="$(cat ~/.ssh/id_ed25519.pub)"
  container_name=$(get_container_name $1)

  mkdir -p ~/workspaces/$1
  echo "Creating devcontainer $container_name"
  $CONTAINER_ENGINE run -d --privileged --name $container_name \
    --volume /home/$USER/workspaces/$1:/workspaces --volume /var/run/docker.sock:/var/run/docker.sock \
    --network=host --restart=always --dns=127.0.0.53 \
    --env CUSTOM_SSH_PORT=$available_port --env KEY_TO_AUTHORIZE="$key_to_authorize" --env DEVCONTAINER_NAME=$1 \
    $DEVCONTAINER_IMAGE

  echo "Updating devcontainers db entries"
  echo "insert into devcontainers (name, port) VALUES ('$container_name', '$available_port');" | sqlite4 $DEVCONTAINERS_DB_FILE_PATH

  echo "Running setup script"
  # $CONTAINER_ENGINE exec -it $containerName bash -c "curl -s $DEVCONTAINER_SETUP_SCRIPT_URL | bash -s"
}

devcontainer_start() {
  $CONTAINER_ENGINE start $(get_container_name $1)
}

devcontainer_stop() {
  $CONTAINER_ENGINE stop $(get_container_name $1)
}

devcontainer_rm() {
  name=$(echo "select name from devcontainers d where d.name='$1';" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH)
  echo $name
  if [[ "$name" = "" ]]; then
    echo "Devcontainer $1 not found. If you created it directly through $CONTAINER_ENGINE use the command '$CONTAINER_ENGINE rm $1' to remove it."
    exit 1
  fi
  devcontainer_stop $1
  $CONTAINER_ENGINE rm $(get_container_name $1)
  echo "delete from devcontainer where name=$1;" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH
}

devcontainer_exec() {
  devcontainer_start $1
  $CONTAINER_ENGINE exec -it $(get_container_name $1) bash
}

devcontainer_proxy() {
  local port=$(echo "select port from devcontainers d where d.name='$1';" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH)
  ssh -o ForwardAgent=yes -W localhost:$port dev@localhost -p "$port"
}

devcontainer_ssh() {
  local port=$(echo "select port from devcontainers d where d.name='$1';" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH)
  ssh -o ForwardAgent=yes -o User=$DEVCONTAINER_USER dev@localhost -p "$port"
}

devcontainer_connect() {
  local names=$(echo "select name from devcontainers;" | sqlite3 $DEVCONTAINERS_DB_FILE_PATH)
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

    echo $devcontainer
    devcontainer_ssh $devcontainer
    exit 0
  done
}

check_and_setup
devcontainer $@

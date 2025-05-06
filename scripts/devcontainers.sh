DEVCONTAINER_IMAGE=raulbrennersc/devcontainer:latest
DEVCONTAINER_SETUP_SCRIPT_URL=https://raw.githubusercontent.com/raulbrennersc/dotfiles/refs/heads/main/setup-devcontainer.sh
CONTAINER_ENGINE=docker

devcontainer() {
  case $1 in
  "up")
    devcontainerUp $2 $3
    ;;

  "start")
    devcontainerStart $2
    ;;

  "stop")
    devcontainerStop $2
    ;;

  "rm")
    devcontainerRm $2
    ;;

  "exec")
    devcontainerExec $2
    ;;

  "ssh")
    devcontainerMux $2
    ;;

  "test")
    devcontainerTest $@
    ;;

  *)
    echo "unrecognized option $1"
    ;;
  esac
}

getContainerName() {
  echo "${1}.devcontainer"
}

devcontainerTest() {
  echo $@
}

devcontainerUp() {
  KEY_TO_AUTHORIZE="$(cat ~/.ssh/id_ed25519.pub)"
  containerName=$(getContainerName $1)

  mkdir -p ~/workspaces/$1

  $CONTAINER_ENGINE run -d --privileged --name $containerName \
    --volume /home/$USER/workspaces/$1:/workspaces --volume /var/run/docker.sock:/var/run/docker.sock \
    --network=host --restart=always --dns=127.0.0.53 \
    --env CUSTOM_SSH_PORT=$2 --env KEY_TO_AUTHORIZE=$KEY_TO_AUTHORIZE --env DEVCONTAINER_NAME=$1 \
    $DEVCONTAINER_IMAGE
  $CONTAINER_ENGINE exec -it $containerName bash -c "curl -s $DEVCONTAINER_SETUP_SCRIPT_URL | bash -s"
}

devcontainerStart() {
  $CONTAINER_ENGINE start $(getContainerName $1)
}

devcontainerStop() {
  $CONTAINER_ENGINE stop $(getContainerName $1)
}

devcontainerRm() {
  devcontainerStop $1
  $CONTAINER_ENGINE rm $(getContainerName $1)
}

devcontainerMux() {
  devcontainerStart $1
  wezterm connect SSHMUX:$(getContainerName $1) &
  disown
}

devcontainerExec() {
  devcontainerStart $1
  $CONTAINER_ENGINE exec -it $(getContainerName $1) bash
}

devcontainer $@

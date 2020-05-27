#!/usr/bin/env bash


function install_on_osx()
{
  BIN_FOLDER=${HOME}/.local/bin
  mkdir -p ${BIN_FOLDER}
  curl -o ${BIN_FOLDER}/aws-azure-login https://raw.githubusercontent.com/searchmetrics/aws-azure-login/master/docker-launch.sh
  chmod +x ${BIN_FOLDER}/aws-azure-login
  echo ${PATH}|grep "${HOME}/.local/bin" >/dev/null || echo -e "\nPlease add '${HOME}/.local/bin' to your \$PATH"
  mkdir -p ${HOME}/.aws
}

function install_on_linux()
{
  curl -s https://raw.githubusercontent.com/searchmetrics/public_gists/master/installers/.shared_shell_functions \
     -o .shared_shell_functions
  source .shared_shell_functions

  BIN_FOLDER=/usr/local/bin

  enter_sudo
  sudo curl -s https://raw.githubusercontent.com/searchmetrics/aws-azure-login/master/docker-launch.sh \
    -o ${BIN_FOLDER}/aws-azure-login
  sudo chmod +x ${BIN_FOLDER}/aws-azure-login
  exit_sudo
  mkdir -p ${HOME}/.aws
  sudo chown -R $(id -u) ${HOME}/.aws
}

OS=${OSTYPE%%[0-9\.]*}
if [ "${OS}" = "darwin" ]
then
  install_on_osx
elif [ "${OS}" = "linux-gnu" ]
then
  install_on_linux
fi

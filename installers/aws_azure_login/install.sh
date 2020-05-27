#!/usr/bin/env bash

BIN_FOLDER=${HOME}/.local/bin
mkdir -p ${BIN_FOLDER}

curl -o ${BIN_FOLDER}/aws-azure-login https://raw.githubusercontent.com/searchmetrics/aws-azure-login/master/docker-launch.sh
chmod +x ${BIN_FOLDER}/aws-azure-login
echo ${PATH}|grep "${HOME}/.local/bin" >/dev/null || echo -e "\nPlease add '${HOME}/.local/bin' to your \$PATH"
mkdir -p ${HOME}/.aws

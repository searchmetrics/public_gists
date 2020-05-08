#!/usr/bin/env bash
set -e
BIN_FOLDER=${HOME}/bin
mkdir -p ${BIN_FOLDER}

function install_on_osx()
{
  curl -sq "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
  curl -sq "https://raw.githubusercontent.com/searchmetrics/public_gists/master/installers/aws_cli/choices.xml.dist" \
    | sed -E "s#\[DEFAULT_INSTALL_FOLDER\]#${BIN_FOLDER}#" > choices.xml

  installer -pkg AWSCLIV2.pkg \
    -target CurrentUserHomeDirectory \
    -applyChoiceChangesXML $(pwd)/choices.xml

  mkdir -p "${HOME}/.local/bin"
  ln -s ${BIN_FOLDER}/aws-cli/aws ${HOME}/.local/bin/aws 2>/dev/null|| true
  echo ${PATH}|grep "${HOME}/.local/bin" >/dev/null || echo -e "\nPlease add '${HOME}/.local/bin' to your \$PATH"
}

if [ "${OSTYPE%%[0-9\.]*}" = "darwin" ]
then
  install_on_osx
fi

## silently try to remove bin folder - will only succeed if still empty
rmdir ${BIN_FOLDER} 2> /dev/null || true


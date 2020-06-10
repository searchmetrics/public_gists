#!/usr/bin/env bash

# exit if the param is not given

USAGE="Please provide the name of the tool to install as argument.

Available tools are:
 - aws_azure_login  installs the azure_login docker wrapper
 - aws_cli            installs the AWS CLI for current user to
                       '${HOME}/.local/bin/aws-cli'
 - loopback_alias   adds the IP address 10.254.254.254 as an alias to
                      the local network interface to provide a common IP address
                      for docker containers to reach the host
 - nginx_proxy     adds a locally nginx-proxy that allows to reach dockerized projects under
                      the http://yourproject.docker schema

Example:
  curl -sq https://raw.githubusercontent.com/searchmetrics/public_gists/master/installers/install.sh | bash -s aws_cli
"
if [ $# == 0 ] ; then
    echo -e "$USAGE"
    exit 1;
fi

INSTALL_TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')
# Make sure it gets removed even if the script exits abnormally.

trap "exit 1"                      HUP INT PIPE QUIT TERM
trap 'rm -rf "${INSTALL_TMP_DIR}"' EXIT

## check if tool is available locally (e.g. from checked out project)
if [ -d "${1}" ]
then
  mkdir -p "${INSTALL_TMP_DIR}"/public_gists-master/installers || exit
  (# also copy hidden files
  shopt -s dotglob
  cp -r ./* "${INSTALL_TMP_DIR}"/public_gists-master/installers/
  )
  cd "${INSTALL_TMP_DIR}" || exit
else
  ## or download archive
  cd "${INSTALL_TMP_DIR}" || exit

  ## download complete archive
  curl -Ls https://github.com/searchmetrics/public_gists/archive/master.zip \
       | bsdtar -xvf-
fi

## go to selected tool's install folder
cd public_gists-master/installers/"${1}" ||exit

# execute requested script
if [ "$(head -c 2 install.sh)" = "#!" ]
then
  chmod +x install.sh
  ./install.sh
else
  echo "No valid installer for ${1} found."
fi

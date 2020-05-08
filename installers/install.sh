#!/usr/bin/env bash

# exit if the param is not given
USAGE="Please provide the name of the tool to install as argument.

Available tools are:
 - aws_cli            installs the AWS CLI for current user to
                       '${HOME}/bin/aws-cli'
 - loopback_alias     adds the IP address 10.254.254.254 as an alias to
                      the local network interface to provide a common IP address
                      for docker containers to reach the host

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

if [ -f ${1}/install.sh ]
then
  cp ${1}/install.sh ${INSTALL_TMP_DIR}
fi

cd ${INSTALL_TMP_DIR}

# (download and) execute requested script
if [ ! -f install.sh ]
then
  curl -sq https://raw.githubusercontent.com/searchmetrics/public_gists/master/installers/${1}/install.sh -o install.sh
fi
if [ "$(head -c 2 install.sh)" = "#!" ]
then
  cat install.sh | bash -s
else
  echo "No valid installer for ${1} found."
fi


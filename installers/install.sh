#!/usr/bin/env bash

# exit if the param is not given
: ${1?:"Please give the name of the tool to install as argument"}

INSTALL_TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir')
# Make sure it gets removed even if the script exits abnormally.

trap "exit 1"                      HUP INT PIPE QUIT TERM
trap 'rm -rf "${INSTALL_TMP_DIR}"' EXIT

cd ${INSTALL_TMP_DIR}

# download and execute requested script
curl -sq https://raw.githubusercontent.com/searchmetrics/public_gists/master/installers/${1}/install.sh | bash -s


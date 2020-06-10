#!/usr/bin/env bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
INSTALLERS_DIR=${SCRIPT_DIR}/..

# shellcheck source=../.shared_shell_functions
source "${INSTALLERS_DIR}"/.shared_shell_functions

set -e
BIN_FOLDER=${HOME}/bin
mkdir -p "${BIN_FOLDER}"

function install_on_osx() {
  sed -E "s#\[DEFAULT_INSTALL_FOLDER\]#${BIN_FOLDER}#" choices.xml.dist \
    > choices.xml

  installer -pkg AWSCLIV2.pkg \
    -target CurrentUserHomeDirectory \
    -applyChoiceChangesXML "${SCRIPT_DIR}/choices.xml"

  mkdir -p "${HOME}/.local/bin"
  ln -s "${BIN_FOLDER}"/aws-cli/aws "${HOME}"/.local/bin/aws 2>/dev/null || true
  echo "${PATH}" | grep "${HOME}/.local/bin" >/dev/null || echo -e "\nPlease add '${HOME}/.local/bin' to your \$PATH"
}

function install_on_linux() {
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  enter_sudo
  sudo ./aws/install
  exit_sudo
}

function _install_aws_cli() {
  _install_os_based
  ## silently try to remove bin folder - will only succeed if still empty
  rmdir "${BIN_FOLDER}" 2>/dev/null || true
}

_install_aws_cli

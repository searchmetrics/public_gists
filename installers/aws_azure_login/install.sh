#!/usr/bin/env bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
INSTALLERS_DIR=${SCRIPT_DIR}/..

# shellcheck source=../.shared_shell_functions
source "${INSTALLERS_DIR}"/.shared_shell_functions

set -e

function _download_script() {
  curl -s https://raw.githubusercontent.com/searchmetrics/aws-azure-login/master/docker-launch.sh \
    - o aws-azure-login
  chmod +x aws-azure-login
  ls aws-azure-login 2>/dev/null
}

function install_on_osx() {
  BIN_FOLDER=${HOME}/.local/bin
  mkdir -p "${BIN_FOLDER}"
  mv "$(_download_script)" "${BIN_FOLDER}"/aws-azure-login
  echo "${PATH}" | grep "${HOME}/.local/bin" >/dev/null || echo -e "\nPlease add '${HOME}/.local/bin' to your \$PATH"
}

function install_on_linux() {
  BIN_FOLDER=/usr/local/bin
  enter_sudo
  sudo mv "$(_download_script)" "${BIN_FOLDER}"/aws-azure-login
  exit_sudo
}

function _install_aws_azure_login() {
  _install_os_based

  mkdir -p "${HOME}"/.aws
}

_install_aws_azure_login

#!/usr/bin/env bash
SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
INSTALLERS_DIR=${SCRIPT_DIR}/..

# shellcheck source=../.shared_shell_functions
source "${INSTALLERS_DIR}"/.shared_shell_functions

function install_on_osx() {
  if [ ! -f "${SCRIPT_DIR}/com.searchmetrics.docker_loopback_alias.plist" ]; then
    curl -sq https://raw.githubusercontent.com/searchmetrics/public_gists/master/installers/loopback_alias/com.searchmetrics.docker_loopback_alias.plist \
            -o com.searchmetrics.docker_loopback_alias.plist
  fi
  enter_sudo
  sudo cp com.searchmetrics.docker_loopback_alias.plist /Library/LaunchDaemons/com.searchmetrics.docker_loopback_alias.plist
  echo ""
  sudo launchctl load /Library/LaunchDaemons/com.searchmetrics.docker_loopback_alias.plist
  exit_sudo
}

function install_on_linux() {
  main_interface=$(ip addr show | awk '/inet.*brd/{print $NF; exit}')
  enter_sudo
  sudo ip addr add 10.254.254.254/24 brd + dev "${main_interface}" label "${main_interface}":1
  exit_sudo
}

_install_os_based

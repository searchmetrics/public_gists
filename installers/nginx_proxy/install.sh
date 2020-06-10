#!/usr/bin/env bash
SCRIPT_DIR=$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
INSTALLERS_DIR=${SCRIPT_DIR}/..

# shellcheck source=../.shared_shell_functions
source "${INSTALLERS_DIR}"/.shared_shell_functions

function install_resolver() {
  if [[ -f /etc/resolver/docker ]]; then
    echo resolver file for domain ".docker" already exists
  else
    enter_sudo
    if [[ ! -d /etc/resolver ]]; then
      sudo mkdir -p /etc/resolver
    fi
    echo setting local dnsmasq as resolver for domain ".docker" to resolve to 127.0.0.1
    ## place resolver
    # shellcheck disable=SC2024
    sudo tee /etc/resolver/docker \
      < "${SCRIPT_DIR}"/dnsmasq/dnsmasq.resolver.docker \
      > /dev/null
    exit_sudo
  fi
}

function install_nginx_proxy() {
  docker-compose build --pull
  docker-compose up -d
  echo nginx-proxy successfully installed.
  echo now add VIRTUAL_HOST=yourservice.docker to you dockerized services
  echo and reach them easily
}

function install_nginx_stack() {
  install_resolver
  install_nginx_proxy
}

install_nginx_stack

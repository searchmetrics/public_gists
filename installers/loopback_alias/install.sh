#!/usr/bin/env bash


source <(curl -s https://raw.githubusercontent.com/searchmetrics/public_gists/master/installers/.shared_shell_functions)

function install_on_osx()
{
  enter_sudo
  sudo curl -o /Library/LaunchDaemons/com.searchmetrics.docker_loopback_alias.plist \
    https://raw.githubusercontent.com/searchmetrics/public_gists/master/installers/loopback_alias/com.searchmetrics.docker_loopback_alias.plist
  sudo launchctl load /Library/LaunchDaemons/com.searchmetrics.docker_loopback_alias.plist
  exit_sudo
}

function install_on_linx()
{
  main_interface=`ip addr show | awk '/inet.*brd/{print $NF; exit}'`
  enter_sudo
  sudo ip addr add 10.254.254.254/24 brd + dev $main_interface label $main_interface:1  
  exit_sudo
}

OS=${OSTYPE%%[0-9\.]*}
if [ "${OS}" = "darwin" ]
then
  install_on_osx
elif [ "${OSTYPE}" = "linux-gnu" ]
then
  install_on_linux
fi

#!/bin/bash
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/functions.sh"

# Source NVM for the script (again in case it was missing)
# https://unix.stackexchange.com/a/184512/194420
# https://github.com/nvm-sh/nvm/issues/1290
if [ -f ~/.nvm/nvm.sh ]; then
  . ~/.nvm/nvm.sh
elif command -v brew; then
  # https://docs.brew.sh/Manpage#--prefix-formula
  BREW_PREFIX=$(brew --prefix nvm)
  if [ -f "$BREW_PREFIX/nvm.sh" ]; then
    . $BREW_PREFIX/nvm.sh
  fi
fi

#================================================
# Output starts here
#================================================
heading

description "Checking for homebrew"
does_homebrew_exist

description "Checking for required dependencies"
does_docker_exist docker
brewIn node
brewIn nvm
brewIn php
brewIn php-code-sniffer

# PHP Standards
description "Setting global PHP standard"
phpcs --config-set default_standard PSR2

# Check Dependencies Exist
system_check wordpress wp-config.php git@github.com:troychaplin/wordpress-starter.git main

description "Building/Pulling Docker Containers"
docker-compose pull && docker-compose build --no-cache

description "Adding localhost certificate to trusted"
sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" ./.config/nginx/certs/localhost.crt

description "All Done!";
echo -e ""
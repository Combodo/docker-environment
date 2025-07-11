#!/bin/bash

source "$(dirname "$0")/utils.sh"

trap 'error_cleanup; print_error "Something unexpected happened. Exiting the wizard."' ERR
set -e #Stops the script on any error
export LANG=fr_FR.UTF-8
export LC_ALL=fr_FR.UTF-8

error_cleanup() {
  if [ -n "$PROJECT_NAME" ] && [ -d "/var/www/html/$PROJECT_NAME" ]; then
    rm -r "/var/www/html/$PROJECT_NAME"
  fi
}

update_permissions() {
  chown www-data:$GROUP_ID $PROJECT_NAME -R
  chmod g+w $PROJECT_NAME -R
}

print_install_success() {
  print_success "Installation successfull"
  echo "Start configuring iTop on http://localhost:88/$PROJECT_NAME."
}

cd /var/www/html

PROJECT_NAME=$(dialog --clear --stdout --inputbox \
  "Choose an iTop project name :\n\
  \n\
  This name should be unique and not contain spaces or special characters.\n\
  It will be used as an installation folder and URL path component." \
  12 100)
clear

if [ -z "$PROJECT_NAME" ]; then
  PROJECT_NAME="iTop"
fi

INSTALL_MODE=$(dialog --clear --stdout --menu "Installation source :" 15 40 4 \
  1 "GitHub" \
  2 "Combodo factory" \
)
clear

case "$INSTALL_MODE" in
  1) source "$(dirname "$0")/git_install.sh" ; install_from_git ;;
  2) source "$(dirname "$0")/factory_install.sh" ; install_from_factory ;;
  *) echo "Invalid option, exiting." ; exit 1 ;;
esac

update_permissions
print_install_success

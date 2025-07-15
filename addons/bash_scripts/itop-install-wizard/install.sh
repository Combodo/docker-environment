#!/bin/bash

. "$(dirname "$0")/includes/utils.sh"
. "$(dirname "$0")/includes/git_install.sh"
. "$(dirname "$0")/includes/factory_install.sh"
. "$(dirname "$0")/../../../.env"

trap 'error_cleanup; print_error "Something unexpected happened. Exiting the wizard."' ERR
set -e #Stops the script on any error

error_cleanup() {
  if [ -n "$PROJECT_NAME" ] && [ -d "$HTML_FOLDER/$PROJECT_NAME" ]; then
    rm -r "$HTML_FOLDER/$PROJECT_NAME"
  fi
}

update_permissions() {
  sudo chown www-data:${SUDO_USER:-$USER} $PROJECT_NAME -R
  sudo chmod g+w $PROJECT_NAME -R
}

print_install_success() {
  print_success "Installation successfull"
  echo "Start configuring iTop on http://localhost:88/$PROJECT_NAME."
}

if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
	exit
fi

cd $HTML_FOLDER

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
  1) install_from_git ;;
  2) install_from_factory ;;
  *) echo "Invalid option, exiting." ; exit 1 ;;
esac

update_permissions
print_install_success

#!/bin/bash

source "$(dirname "$0")/utils.sh"

trap 'print_error "Une erreur est survenue. Arrêt du script."' ERR
set -e #Stops the script on any error
export LANG=fr_FR.UTF-8
export LC_ALL=fr_FR.UTF-8

update_permissions() {
  chown www-data:$GROUP_ID $PROJECT_NAME -R
  chmod g+w $PROJECT_NAME -R
}

print_install_success() {
  print_success "Installation de iTop terminée"
  echo "Vous pouvez maintenant configurer votre projet depuis http://localhost:88/$PROJECT_NAME."
}

cd /var/www/html

PROJECT_NAME=$(dialog --clear --stdout --inputbox \
  "Choisir un nom unique pour votre nouveau projet iTop :\n\
  \n\
  Ce nom servira de dossier d'installation.\n\
  Il servira également dans vos URL." \
  10 50)
clear

if [ -z "$PROJECT_NAME" ]; then
  PROJECT_NAME="iTop"
fi

INSTALL_MODE=$(dialog --clear --stdout --menu "Mode d'installation :" 15 40 4 \
  1 "Depuis GitHub" \
  2 "Depuis la factory" \
)
clear

case "$INSTALL_MODE" in
  1) source "$(dirname "$0")/git_install.sh" ; install_from_git ;;
  2) source "$(dirname "$0")/factory_install.sh" ; install_from_factory ;;
  *) echo "Option invalide. Veuillez réessayer." ; exit 1 ;;
esac

update_permissions
print_install_success

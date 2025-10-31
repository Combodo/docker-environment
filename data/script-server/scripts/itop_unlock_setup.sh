#!/bin/bash

set -euo pipefail

# Color variables
COLOR_DEFAULT='\033[0m'
COLOR_SUCCESS='\033[0;32m'
COLOR_ERROR='\033[0;31m'
COLOR_WARNING='\033[1;33m'
COLOR_INFO='\033[0;34m'

# Script variables
PHP_CONTAINER_NAME=""
PHP_CRON_PID=""

# Default parameters values
ITOP_INSTANCE_REL_PATH=""
ITOP_AUTH_USER=""
ITOP_AUTH_PWD=""
PHP_VERSION=""
VERBOSE=false

print_default() {
  echo -e "${COLOR_DEFAULT}$1${COLOR_DEFAULT}"
}
print_success() {
  echo -e "${COLOR_SUCCESS}$1${COLOR_DEFAULT}"
}
print_error() {
  echo -e "${COLOR_ERROR}$1${COLOR_DEFAULT}"
}
print_warning() {
  echo -e "${COLOR_WARNING}$1${COLOR_DEFAULT}"
}
print_info() {
  echo -e "${COLOR_INFO}$1${COLOR_DEFAULT}"
}

# Parse arguments (handle both --arg=value and --arg value syntax)
while [[ $# -gt 0 ]]; do
  case "$1" in
    --itop-instance=*)
      ITOP_INSTANCE_REL_PATH="${1#*=}"
      shift
      ;;
    --itop-instance)
      ITOP_INSTANCE_REL_PATH="$2"
      shift 2
      ;;
    *)
      echo "❌ Unknown argument: $1"
      exit 1
      ;;
  esac
done

# Check parameters consistency
if [[ -z "${ITOP_INSTANCE_REL_PATH}" ]]; then
  print_error "Some required parameters are missing, make sure to pass --itop-instance."
  exit 1
fi

# Refine parameters
# - Build absolute path to iTop instance on script-server container
ITOP_INSTANCE_LOCAL_ABS_PATH="/host_html/${ITOP_INSTANCE_REL_PATH}"
# - Build absolute path to iTop instance on webserver container
#   Important: `/var/www/html/` is the webserver root path inside the `php` Docker containers
ITOP_INSTANCE_REMOTE_ABS_PATH="/var/www/html/${ITOP_INSTANCE_REL_PATH}"
# - Build absolute path to iTop CRON file (both local and remote)
ITOP_CONF_LOCAL_ABS_PATH="${ITOP_INSTANCE_LOCAL_ABS_PATH}/conf/production/config-itop.php"
ITOP_CONF_REMOTE_ABS_PATH="${ITOP_INSTANCE_REMOTE_ABS_PATH}/conf/production/config-itop.php"

# Display parameters before execution
print_default "About to unlock iTop setup with the following parameters:"
print_default "- iTop instance: ${ITOP_INSTANCE_REL_PATH} (=> ${ITOP_INSTANCE_REMOTE_ABS_PATH} in webserver container)"
print_default "- iTop environment: production"
print_default "- Webserver container: apache"
print_default ""

# Check if config file exists locally to determine if it exists remotely
if [[ ! -f "${ITOP_CONF_LOCAL_ABS_PATH}" ]]; then
  print_error "iTop conf. file could not be found in ${ITOP_CONF_REMOTE_ABS_PATH}"
  exit 1
else
   print_default "iTop conf. file found: ${ITOP_CONF_REMOTE_ABS_PATH}"
fi

# Build command line
CONFIG_COMMAND=$(cat <<EOF
docker exec -i apache chmod +w "${ITOP_CONF_REMOTE_ABS_PATH}"
EOF
)

# Launch CRON job
print_default "Executing: ${CONFIG_COMMAND}"
print_default ""

# Run command synchronously to keep stdout
bash -c "${CONFIG_COMMAND}"

print_success "iTop setup unlocked successfully"

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

# Allow cleanup when user presses STOP in Script-server
cleanup() {
  print_default "Caught stop signal, stopping CRON job..."

  print_default "|- Retrieving its PID..."
  PHP_CRON_PID=$(docker exec ${PHP_CONTAINER_NAME} pgrep -f "${ITOP_CRON_REMOTE_ABS_PATH}")

  if [[ -z "${PHP_CRON_PID}" ]]; then
    print_error "|  => PID could not be found: ${PHP_CRON_PID}"
  else
    print_default "|  => PID found: ${PHP_CRON_PID}"
  fi

  if [[ -n "${PHP_CRON_PID}" ]]; then
    print_default "|- Killing the process..."
    docker exec ${PHP_CONTAINER_NAME} kill ${PHP_CRON_PID} 2>/dev/null || true
    print_default "|  => Process killed"
    print_success "All good!"
  else
    print_error "Impossible to stop the CRON job because its PID could not be found, it will keep running in background until it exits"
  fi
  exit 130  # 130 = terminated by Ctrl+C or STOP
}

# Set trap for termination signals, so it calls the cleanup
# If we don't do that, the PHP script will keep executing on the PHP container even if we click "STOP" in Script-server
trap cleanup SIGINT SIGTERM

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
    --itop-auth-user=*)
      ITOP_AUTH_USER="${1#*=}"
      shift
      ;;
    --itop-auth-user)
      ITOP_AUTH_USER="$2"
      shift 2
      ;;
    --itop-auth-pwd=*)
      ITOP_AUTH_PWD="${1#*=}"
      shift
      ;;
    --itop-auth-pwd)
      ITOP_AUTH_PWD="$2"
      shift 2
      ;;
    --php-version=*)
      PHP_VERSION="${1#*=}"
      shift
      ;;
    --php-version)
      PHP_VERSION="$2"
      shift 2
      ;;
    --verbose)
      VERBOSE=true
      shift
      ;;
    *)
      echo "❌ Unknown argument: $1"
      exit 1
      ;;
  esac
done

# Check parameters consistency
if [[ -z "${ITOP_INSTANCE_REL_PATH}" || -z "${ITOP_AUTH_USER}" || -z "${ITOP_AUTH_PWD}" || -z "${PHP_VERSION}" ]]; then
  print_error "Some required parameters are missing, make sure to pass --itop-instance, --itop-auth-user, --itop-auth-pwd & --php-version."
  exit 1
fi

# Refine parameters
# - Build absolute path to iTop instance on script-server container
ITOP_INSTANCE_LOCAL_ABS_PATH="/host_html/${ITOP_INSTANCE_REL_PATH}"
# - Build absolute path to iTop instance on webserver container
#   Important: `/var/www/html/` is the webserver root path inside the `php` Docker containers
ITOP_INSTANCE_REMOTE_ABS_PATH="/var/www/html/${ITOP_INSTANCE_REL_PATH}"
# - Build absolute path to iTop CRON file (both local and remote)
ITOP_CRON_LOCAL_ABS_PATH="${ITOP_INSTANCE_LOCAL_ABS_PATH}/webservices/cron.php"
ITOP_CRON_REMOTE_ABS_PATH="${ITOP_INSTANCE_REMOTE_ABS_PATH}/webservices/cron.php"
# - Convert PHP version to dotted format if needed (e.g. "81" => "8.1")
PHP_VERSION_AS_DOTTED="${PHP_VERSION:0:1}.${PHP_VERSION:1:1}"
# - Build PHP container name
PHP_CONTAINER_NAME="php${PHP_VERSION_AS_DOTTED}"
# - Convert verbose from boolean to integer (true => 1, false => 0)
VERBOSE_AS_INT=$([[ "${VERBOSE}" == true ]] && echo 1 || echo 0)

# Display parameters before execution
print_default "About to launch iTop CRON job with the following parameters:"
print_default "- iTop instance: ${ITOP_INSTANCE_REL_PATH} (=> ${ITOP_INSTANCE_REMOTE_ABS_PATH} in webserver container)"
print_default "- iTop auth. user: ${ITOP_AUTH_USER}"
print_default "- iTop auth. password: ${ITOP_AUTH_PWD}"
print_default "- PHP version: ${PHP_VERSION} (=> ${PHP_VERSION_AS_DOTTED}, container \"${PHP_CONTAINER_NAME}\" will be used)"
print_default "- Verbose: ${VERBOSE} (=> ${VERBOSE_AS_INT})"
print_default ""

# Check if CRON file exists locally to determine if it exists remotely
if [[ ! -f "${ITOP_CRON_LOCAL_ABS_PATH}" ]]; then
  print_error "iTop CRON file could not be found in ${ITOP_CRON_REMOTE_ABS_PATH}"
  exit 1
else
   print_default "iTop CRON file found: ${ITOP_CRON_REMOTE_ABS_PATH}"
fi

# Build command line
CRON_COMMAND=$(cat <<EOF
docker exec -i ${PHP_CONTAINER_NAME} php "${ITOP_CRON_REMOTE_ABS_PATH}" \
  --auth_user=${ITOP_AUTH_USER} \
  --auth_pwd=${ITOP_AUTH_PWD} \
  --verbose=${VERBOSE_AS_INT}
EOF
)

# Launch CRON job
print_default "Executing: ${CRON_COMMAND}"
print_default ""

# Run command synchronously to keep stdout
bash -c "${CRON_COMMAND}"

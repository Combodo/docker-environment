#!/bin/bash

set -euo pipefail

# Color variables
COLOR_DEFAULT='\033[0m'
COLOR_SUCCESS='\033[0;32m'
COLOR_ERROR='\033[0;31m'
COLOR_WARNING='\033[1;33m'
COLOR_INFO='\033[0;34m'

# Variables
REPOSITORY_ORGANIZATION="Combodo"
REPOSITORY_NAME="docker-environment"
RELEASE_ZIP_URL="https://github.com/${REPOSITORY_ORGANIZATION}/${REPOSITORY_NAME}/archive/refs/tags"
TMP_CURRENT_FOLDER="/tmp/docker-environment-update"
# Save current folder path so we can return to it later
CURRENT_FOLDER="$(pwd)"
LOG_FILE="${CURRENT_FOLDER}/auto-update.log"

# Helpers
print_default() {
  echo -e "${COLOR_DEFAULT}$1${COLOR_DEFAULT}"
}
print_inline_default() {
  echo -n -e "${COLOR_DEFAULT}$1${COLOR_DEFAULT}"
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
print_inline_warning() {
  echo -n -e "${COLOR_WARNING}$1${COLOR_DEFAULT}"
}
print_info() {
  echo -e "${COLOR_INFO}$1${COLOR_DEFAULT}"
}
# Helper to run a command and log its output (stdout+stderr) for debug purposes
# Usage: `run_and_log <mode> <command> [args...]` where <mode> is 'w' to overwrite the log file or 'a' to append
run_and_log() {
  local mode="$1"
  shift
  if [ "$mode" = "w" ]; then
    "$@" > "$LOG_FILE" 2>&1
  else
    "$@" >> "$LOG_FILE" 2>&1
  fi
}

# Init log file
run_and_log w echo "Auto-update launched on $(date '+%Y-%m-%d %H:%M:%S')"

# Load current environment variables
if [ -f .env.local ]; then
  set -a
  source .env.local
  set +a
  print_info "Environment variables loaded from .env.local."
elif [ -f .env ]; then
  set -a
  source .env
  set +a
  print_info "Environment variables loaded from .env."
else
  print_error "Neither .env.local nor .env file could be found, update can't proceed."
fi

print_inline_default "Do you want to proceed? (y/n) [y] "
read -r proceed_answer
proceed_answer=${proceed_answer:-y}
if [[ "$proceed_answer" != "y" ]]; then
  print_error "Update aborted."
  exit 1
fi
print_default ""

# Step 1
print_default "+------------------------------+"
print_default "| Step 1/4 Update source files |"
print_default "+------------------------------+"
if [ -d .git ]; then
  print_default "Git clone detected, updating it via git pull..."
  if ! git pull --rebase; then
    print_inline_warning "Uncommitted files detected, do you want to force the update? You will loose you uncommitted files. (y/n) [n] "
    read -r force_git_reset_answer
    force_git_reset_answer=${force_git_reset_answer:-n}
    if [[ "${force_git_reset_answer}" == "y" ]]; then
      print_default "Reverting uncommitted changes..."
      git reset --hard
      print_default "Pulling latest changes..."
      git pull --rebase
    else
      print_error "Update aborted."
      exit 1
    fi
  fi
else
  print_default "No Git clone detected, assuming it's an unzipped release. Retrieving last release from GitHub..."

  # Find latest release
  LATEST_RELEASE=$(curl -s "https://api.github.com/repos/${REPOSITORY_ORGANIZATION}/${REPOSITORY_NAME}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  if [ -z "$LATEST_RELEASE" ]; then
    print_error "Could not find latest release."
    exit 1
  fi
  print_info "Latest release found: ${LATEST_RELEASE}"

  print_inline_warning "You are about to deploy v${LATEST_RELEASE} of the environment into ${CURRENT_FOLDER}, do you want to proceed? (y/n) [n] "
  read -r deploy_git_release_answer
  deploy_git_release_answer=${deploy_git_release_answer:-n}
  if [[ "${deploy_git_release_answer}" != "y" ]]; then
    print_error "Update aborted."
    exit 1
  fi

  # Extract release zip to temporary folder
  print_default "Creating temporary folder (${TMP_CURRENT_FOLDER}) to download and extract the latest release..."
  mkdir -p "${TMP_CURRENT_FOLDER}"
  cd "${TMP_CURRENT_FOLDER}"

  print_default "Downloading latest release..."
  run_and_log a curl -L -o latest.zip "$RELEASE_ZIP_URL/$LATEST_RELEASE.zip"

  print_default "Extracting latest release..."
  run_and_log a unzip -o latest.zip
  # Copy files to current folder (except .git if existing but it should not)
  # - Note: The --no-perms option is used to preserved permissions of existing files
  print_default "Copying files to current folder (${CURRENT_FOLDER})..."
  run_and_log a rsync -a --no-perms --exclude='.git' "${REPOSITORY_NAME}-${LATEST_RELEASE}/" "${CURRENT_FOLDER}/"
  cd "${CURRENT_FOLDER}"

  # Clean temporary folder
  print_default "Cleaning up temporary folder..."
  rm -rf "${TMP_CURRENT_FOLDER}"
fi
print_success "Update complete."
print_default ""

# Step 2
print_default "+--------------------------------------------------------------+"
print_default "| Step 2/4 Synchronize .env.local with new variables from .env |"
print_default "+--------------------------------------------------------------+"
if [ -f .env.local ]; then
  print_default "Looking for variables that are not already in .env.local..."
  # For each var that of .env that is not already in .env.local, append it at the end of .env.local
  while IFS= read -r line; do
    # Ignore empty lines and comments
    if [[ "$line" =~ ^[[:space:]]*$ || "$line" =~ ^[[:space:]]*# ]]; then
      continue
    fi

    var_name="${line%%=*}"
    # Ignore variables with empty names
    if [[ -z "${var_name}" ]]; then
      continue
    fi

    # Ignore variable that already exists in .env.local
    if grep -qE "^${var_name}=" .env.local; then
      continue
    fi

    # Ajoute un commentaire avec la date avant d'ajouter la variable
    echo "# Added from .env during Docker Environment update on $(date '+%Y-%m-%d %H:%M:%S')" >> .env.local
    echo "${line}" >> .env.local
    print_default "Added ${var_name} to .env.local"
  done < .env
  print_success "Synchronization complete."
else
  print_warning "No .env.local file found, you should consider creating one based on .env to override default variables."
fi
print_default ""

# Step 3
print_default "+---------------------------------------------+"
print_default "| Step 3/4 Deploy default configuration files |"
print_default "+---------------------------------------------+"
print_default "Copying files from 'build/default_configuration' to ${CONF_FOLDER}"
cp -R build/default_configuration/* $CONF_FOLDER
print_success "Deployment complete."
print_default ""

# Step 4
print_default "+-----------------------------------------+"
print_default "| Step 4/4 Rebuild and restart containers |"
print_default "+-----------------------------------------+"
print_inline_default "Do you want to rebuild and restart the Docker containers now? (y/n) [y] "
read -r rebuild_containers_answer
rebuild_containers_answer=${rebuild_containers_answer:-y}
if [[ "${rebuild_containers_answer}" == "y" ]]; then
  print_default "Stopping containers..."
  docker compose down
  print_default "Rebuilding containers..."
  docker compose build --no-cache
  print_default "Starting containers..."
  docker compose up -d
  print_success "Containers restarted."
else
  print_warning "Rebuild and restart skipped. Please remember to manually rebuild and restart your Docker containers to apply the updates."
fi
print_default ""

print_success "Update and deployment successful!"

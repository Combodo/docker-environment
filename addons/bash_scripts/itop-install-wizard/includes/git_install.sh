update_git_config_safe_directory() {
  DIR="$HTML_FOLDER/$PROJECT_NAME"
  CONFIG="$PROJECT_NAME/.git/config"
  if ! grep -Fxq "    directory = $DIR" "$CONFIG"; then
    if ! grep -Fxq "[safe]" "$CONFIG"; then
      echo -e "\n[safe]\n    directory = $DIR" >> "$CONFIG"
    else
      sed -i "/^\[safe\]/a\    directory = $DIR" "$CONFIG"
    fi
  fi
}

get_remote_refs_from_branches() {
  REFS=($(git ls-remote --heads --refs https://github.com/Combodo/iTop.git | awk -F'refs/heads/' '{print $2}'))
}

get_remote_refs_from_tags() {
  REFS=($(git ls-remote --tags --refs https://github.com/Combodo/iTop.git | awk -F'refs/tags/' '{print $2}'))
}

select_remote_git_ref() {
  local MENU_ITEMS=()
  local i=1
  for tag in "${REFS[@]}"; do
    MENU_ITEMS+=($i "$tag")
    ((i++))
  done

  local CHOICE=$(dialog --clear --stdout --menu "Choose a reference :" 20 60 10 "${MENU_ITEMS[@]}")

  local SELECTED_TAG="${REFS[$((CHOICE-1))]}"
  echo "$SELECTED_TAG"
}

select_git_ref() {
  GIT_REF_MODE=$(dialog --clear --stdout --menu "Git source :" 15 40 4 \
    1 "develop" \
    2 "Select a branch" \
    3 "Select a version (tag)" \
  )

  case "$GIT_REF_MODE" in
    1) echo "develop" ;;
    2) get_remote_refs_from_branches && echo $(select_remote_git_ref) ;;
    3) get_remote_refs_from_tags && echo $(select_remote_git_ref) ;;
    *) echo "Invalid option, exiting." ; exit 1 ;;
  esac
}

install_from_git() {
  GIT_REF=$(select_git_ref)
  clear

  git clone --branch $GIT_REF --single-branch https://github.com/Combodo/iTop.git $PROJECT_NAME

  update_git_config_safe_directory
}
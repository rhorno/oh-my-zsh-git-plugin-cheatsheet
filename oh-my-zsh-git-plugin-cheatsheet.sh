#!/bin/bash

# Oh My Zsh Git Plugin Cheatsheet
# This script displays a formatted cheatsheet of git aliases and functions from oh-my-zsh
# Usage: ./oh-my-zsh-git-plugin-cheatsheet.sh [search_term]
# Version: 1.1.0

# Config
PLUGIN_PATH="$HOME/.oh-my-zsh/plugins/git/git.plugin.zsh"
README_PATH="$HOME/.oh-my-zsh/plugins/git/README.md"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CACHE_FILE="$SCRIPT_DIR/git_aliases_cache.txt"
CACHE_DATE_FILE="$SCRIPT_DIR/git_aliases_cache_date.txt"
CACHE_EXPIRY_DAYS=30
SEARCH_TERM="$1"

# ANSI color codes
BOLD="\033[1m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

# Function to check if cache is expired
is_cache_expired() {
  if [[ ! -f "$CACHE_DATE_FILE" ]]; then
    return 0  # Cache date file doesn't exist, so cache is expired
  fi

  local cache_date=$(cat "$CACHE_DATE_FILE")
  local current_date=$(date +%s)
  local diff_seconds=$((current_date - cache_date))
  local diff_days=$((diff_seconds / 86400))

  if [[ $diff_days -gt $CACHE_EXPIRY_DAYS ]]; then
    return 0  # Cache is expired
  else
    return 1  # Cache is still valid
  fi
}

# Function to extract and format aliases and functions
generate_cheatsheet() {
  # Check if plugin file exists
  if [[ ! -f "$PLUGIN_PATH" ]]; then
    echo -e "${BOLD}${RED}Error:${RESET} Git plugin file not found at $PLUGIN_PATH"
    echo "Please make sure oh-my-zsh is installed with the git plugin."
    exit 1
  fi

  # Title and version
  echo -e "${BOLD}${GREEN}Oh My Zsh Git Plugin Cheatsheet${RESET}"
  echo -e "${YELLOW}Type 'gcheat [search_term]' to filter results${RESET}\n"

  # Extract aliases
  echo -e "${BOLD}${GREEN}GIT ALIASES${RESET}\n"
  grep "^alias" "$PLUGIN_PATH" |
    grep -v "# deprecated" |
    sed 's/alias //' |
    sed 's/=/ → /' |
    sed 's/"//g' |
    sed "s/'//g" |
    sort |
    while read -r line; do
      # Format each alias
      alias_name=$(echo "$line" | cut -d' ' -f1)
      command=$(echo "$line" | cut -d'→' -f2- | xargs)

      echo -e "  ${BOLD}${BLUE}${alias_name}${RESET} → ${command}"
    done

  # Extract functions
  echo -e "\n${BOLD}${GREEN}GIT FUNCTIONS${RESET}\n"

  # Function definitions with descriptions
  echo -e "  ${BOLD}${BLUE}current_branch${RESET}"
  echo -e "    Returns the name of the current branch"

  echo -e "  ${BOLD}${BLUE}git_current_user_email${RESET}"
  echo -e "    Returns the user.email config value"

  echo -e "  ${BOLD}${BLUE}git_current_user_name${RESET}"
  echo -e "    Returns the user.name config value"

  echo -e "  ${BOLD}${BLUE}git_develop_branch${RESET}"
  echo -e "    Returns the name of the development branch (dev, devel, development)"

  echo -e "  ${BOLD}${BLUE}git_main_branch${RESET}"
  echo -e "    Returns the name of the main branch (main or master)"

  echo -e "  ${BOLD}${BLUE}grename${RESET}"
  echo -e "    Renames branch <old> to <new>, including on the origin remote"

  echo -e "  ${BOLD}${BLUE}gbda${RESET}"
  echo -e "    Deletes all merged branches"

  echo -e "  ${BOLD}${BLUE}gbds${RESET}"
  echo -e "    Deletes all squash-merged branches"

  echo -e "  ${BOLD}${BLUE}gccd${RESET}"
  echo -e "    Changes to the top level directory of git repo"

  echo -e "  ${BOLD}${BLUE}gdnolock${RESET}"
  echo -e "    Git diff without lockfiles"

  echo -e "  ${BOLD}${BLUE}gdv${RESET}"
  echo -e "    Git diff with your favorite diff viewer"

  echo -e "  ${BOLD}${BLUE}ggf${RESET}"
  echo -e "    Git force push with lease"

  echo -e "  ${BOLD}${BLUE}ggfl${RESET}"
  echo -e "    Git force push with lease to a specific branch"

  echo -e "  ${BOLD}${BLUE}ggl${RESET}"
  echo -e "    Git pull from the origin remote"

  echo -e "  ${BOLD}${BLUE}ggp${RESET}"
  echo -e "    Git push to the origin remote"

  echo -e "  ${BOLD}${BLUE}ggpnp${RESET}"
  echo -e "    Git pull from and push to the origin remote"

  echo -e "  ${BOLD}${BLUE}ggu${RESET}"
  echo -e "    Git pull upstream (rebases by default)"

  echo -e "  ${BOLD}${BLUE}gunwipall${RESET}"
  echo -e "    Removes the WIP prefix from all commits that have it"

  echo -e "  ${BOLD}${BLUE}work_in_progress${RESET}"
  echo -e "    Adds or removes the WIP prefix from a commit message"
}

# Function to search for term and display results
search_cheatsheet() {
  local search_term="$1"
  local cache_file="$2"
  local in_aliases=1
  local in_functions=0
  local matches=0

  # Display the title
  echo -e "${BOLD}${GREEN}Oh My Zsh Git Plugin Cheatsheet${RESET}"
  echo -e "${YELLOW}Searching for: '${search_term}'${RESET}\n"

  # Display section headers
  echo -e "${BOLD}${GREEN}GIT ALIASES${RESET}\n"

  # First count the matches to know if we have any
  matches=$(grep -i "$search_term" "$cache_file" | wc -l)

  # If no matches were found
  if [[ $matches -eq 0 ]]; then
    echo -e "${BOLD}${YELLOW}No matches found for:${RESET} $search_term"
    return
  fi

  # Find and display all matches
  grep -i "$search_term" "$cache_file" | while IFS= read -r line; do
    # Skip section headers
    if [[ "$line" =~ "GIT ALIASES" || "$line" =~ "GIT FUNCTIONS" ]]; then
      continue
    fi

    # If this is the first function and we're still showing aliases header
    if [[ "$line" =~ "  ${BOLD}${BLUE}" && ! "$line" =~ "→" && $in_aliases -eq 1 ]]; then
      in_aliases=0
      in_functions=1
      echo -e "\n${BOLD}${GREEN}GIT FUNCTIONS${RESET}\n"
    fi

    echo "$line"
  done
}

# Main execution
main() {
  # Check if we need to update the cache
  if [[ ! -f "$CACHE_FILE" ]] || is_cache_expired; then
    # Generate the cheatsheet and save to cache
    generate_cheatsheet > "$CACHE_FILE"
    # Update cache date
    date +%s > "$CACHE_DATE_FILE"
  fi

  # If a search term is provided, filter the output
  if [[ -n "$SEARCH_TERM" ]]; then
    search_cheatsheet "$SEARCH_TERM" "$CACHE_FILE"
  else
    # Display the complete cheatsheet
    cat "$CACHE_FILE"
  fi
}

main
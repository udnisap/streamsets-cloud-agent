#!/usr/bin/env bash

function validate_command() {
  # Call using command to validate and where to get it if not installed (optional)
  # i.e. validate_command "jq" "sudo apt install jq"
  if ! [ -x "$(command -v $1)" ]; then
    echo "Error: $1 is not installed." >&2
    shift
    echo $@
    exit 1
  fi
}

function validate_file() {
  # Call using file to check if there and exit if not.
  if [ ! -f $1 ]; then
    echo "File not found: ${1}"
    exit 1
  fi
}

#!/usr/bin/env bash

CURRENT_DIR=$(pwd)

# Path of current script
BASEDIR=$(dirname $(realpath "$0"))

# Create venv if not exists and active it
if [ ! -d "${BASEDIR}/venv/" ]; then
  echo -e "⚠️ virtualenv is not present (${BASEDIR}/venv/ doesn't exists"
  virtualenv -p "$(which python3)" "${BASEDIR}/venv/"
  # shellcheck source=venv/bin/activate
  source "${BASEDIR}/venv/bin/activate"
fi

# Install dependencies
pip install -r "${BASEDIR}/requirements.txt"

# Create zip file (for AWS)
ZIP_FILE="${BASEDIR}/lambda.zip"
cd "${BASEDIR}/venv/lib/python3.8/site-packages" || exit 1
zip -9 -r "${ZIP_FILE}" .
cd "${BASEDIR}/src" || exit 1
zip -9 -r -g "${ZIP_FILE}" .

# Go back to BASEDIR
cd "$CURRENT_DIR" || exit 1
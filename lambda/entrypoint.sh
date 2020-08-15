#!/usr/bin/env bash

BASE_DIR="$(dirname $(realpath "$0"))"
PACKAGE_DIR="${BASE_DIR}/package"
ZIP_FILE="${BASE_DIR}/lambda.zip"

mkdir -p "$PACKAGE_DIR" && cd "$PACKAGE_DIR" || exit 1
cp "${BASE_DIR}/lambda.py" "${PACKAGE_DIR}/"
pip install -r "${BASE_DIR}/requirements.txt" -t ./

if [ -f "$ZIP_FILE" ]; then
  rm "$ZIP_FILE"
fi

zip -9qr "$ZIP_FILE" .
rm -r "$PACKAGE_DIR"
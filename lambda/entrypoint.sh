#!/usr/bin/env bash

BASE_DIR="$(dirname $(realpath "$0"))"
VENV="docker-venv"
SITE_PACKAGES="${BASE_DIR}/${VENV}/lib/python3.8/site-packages"

python -m venv "${VENV}"

pip install --upgrade pip
pip install -r requirements.txt

cp lambda.py "$SITE_PACKAGES"
cd "$SITE_PACKAGES" || exit 1

zip -9qr "${BASE_DIR}/lambda.zip" .

rm -r "${BASE_DIR}/${VENV}"
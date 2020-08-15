#!/usr/bin/env bash

CURRENT_DIR=$(pwd)
cd "$(dirname $(realpath "$0"))" || exit 1

if ! command -v docker &>/dev/null; then
  echo "⚠️ You need Docker to build the ZIP lambda function"
fi

docker run --rm \
  -w /build \
  -v "$PWD:/build" \
  --entrypoint /build/entrypoint.sh \
  lambci/lambda:build-python3.8

# Go back to origin directory
cd "$CURRENT_DIR" || exit 1
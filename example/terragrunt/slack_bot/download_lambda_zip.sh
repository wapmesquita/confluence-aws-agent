#!/bin/bash
set -e


ZIP_URL="https://github.com/wapmesquita/confluence-aws-agent/releases/download/v0.1.0/src.zip"
ZIP_FILE="src.zip"

echo "Downloading lambda zip file from ${ZIP_URL} at ${PWD}/${ZIP_FILE}"

# Download the zip file
curl -L -o "${ZIP_FILE}" "${ZIP_URL}" 
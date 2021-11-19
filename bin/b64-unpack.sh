#!/usr/bin/env bash

set -euo pipefail


# Unpack Base64 tarball
# If a folder is specified, tentatively create it
#  and then unpack into it

if [[ -n "${1:-}" ]]; then
    echo "Unpacking to subfolder: $1"
    mkdir -p "$1"
    cd "$1"
fi

echo -e "Paste your Base64 tarball data (end input with Ctrl + D) ...\n"

(
    base64 -di
    echo "---" >&2
) | tar xzv

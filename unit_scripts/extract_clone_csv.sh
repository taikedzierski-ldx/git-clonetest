#!/usr/bin/env bash

set -euo pipefail

[[ -n "$*" ]] || {
	echo "No raw data file supplied"
	exit 1
}

cd "$(dirname "$0")"
. LOOP_CONFIG.sh

CSV_FILES=(:)

for DATAFILE in "$@"; do

	CSV_NAME="$DATAFILE.csv"

	grep -vE '^#' "$DATAFILE" | sed -r 's/\s+'"$REPO_NAME"'$//' > "$CSV_NAME"

	echo
	echo "Extracted data"
	ls "$CSV_NAME"

	CSV_FILES+=("$CSV_NAME")
done

echo
echo Base64 tarball
echo
tar cz "${CSV_FILES[@]:1}" | base64

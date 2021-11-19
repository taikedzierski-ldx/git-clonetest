#!/usr/bin/env bash

HERE="$(dirname "$0")"
cd "$HERE"

. "LOOP_CONFIG.sh"

set -euo pipefail
sleep_seconds=$(( 60 * 10 ))
datafile="$(date +%F)_${LOCATION}_${UNIT_NAME}-clone-data.txt"
set +e

wait_for() {
	i=$1
	echo -n "Sleeping $i seconds "

	while [[ $i -gt 0 ]]; do
		dec=10 # Step (seconds) between tty feedback
		echo -n "."
		sleep $dec
		i=$((i-dec))
	done
	echo
}


main() {
	while true; do
		[[ ! -d "$REPO_NAME" ]] || rm -rf "$REPO_NAME"

		START_DATE="$(date '+%F %T')"

		# Most entries start with '#' as comments
		echo "# START -- $START_DATE" >> "$datafile"
		git clone --no-checkout "$REPO_URL" "$REPO_NAME"
		
		END_DATE="$(date '+%F %T')"
		BYTE_SIZE="$(du -s "$REPO_NAME")"

		echo "# Size     : $BYTE_SIZE" >> "$datafile"
		echo "# Size (-h): $(du -sh "$REPO_NAME")" >> "$datafile"
		echo "# END -- $END_DATE" >> "$datafile"

		# A CSV data line
		echo "$START_DATE,$END_DATE,$BYTE_SIZE" >> "$datafile"
		echo "# ====" >> "$datafile"

		wait_for $sleep_seconds
	done
}

main "$@"

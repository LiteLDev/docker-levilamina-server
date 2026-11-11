#! /usr/bin/env bash
# Checks the log of a container after the server started: every mod in /data/mods was loaded and
# enabled by LeviLamina, and nothing was logged as an error.
#
# Usage: test/check-mods.sh <container>

set -euo pipefail

NAME="$1"
LOG="$(docker logs "$NAME" 2>&1 | sed 's/\x1b\[[0-9;]*m//g')"

mapfile -t MODS < <(docker exec "$NAME" sh -c 'for d in /data/mods/*/; do basename "$d"; done')
echo "Mods: ${MODS[*]}"
[ "${#MODS[@]}" -gt 1 ] || { echo "::error::No mod is installed."; exit 1; }

bad=0
for mod in "${MODS[@]}"; do
    # LeviLamina is the loader; it loads every other mod.
    [ "$mod" = LeviLamina ] && continue
    grep -qF "[LeviLamina] $mod loaded" <<<"$LOG" \
        || { echo "::error::LeviLamina did not load $mod."; bad=1; }
    grep -qE "\[LeviLamina\] Enabling $mod v" <<<"$LOG" \
        || { echo "::error::LeviLamina did not enable $mod."; bad=1; }
done

# Log levels: LeviLamina writes ERR and FTL, PreLoader ERROR and FATAL.
if grep -E '^[0-9:.]+ +(ERR|FTL|ERROR|FATAL) ' <<<"$LOG"; then
    echo "::error::The log has errors."
    bad=1
fi

exit "$bad"

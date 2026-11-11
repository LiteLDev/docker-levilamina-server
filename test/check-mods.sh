#! /usr/bin/env bash
# Checks that every mod installed in the container's /data/mods was loaded by LeviLamina, as its log
# says, and that the log reports no error.
#
# Usage: test/check-mods.sh <container>

set -euo pipefail

NAME="$1"
LOG="$(docker logs "$NAME" 2>&1)"

mapfile -t MODS < <(docker exec "$NAME" sh -c 'for d in /data/mods/*/; do basename "$d"; done')
echo "Mods: ${MODS[*]}"
[ "${#MODS[@]}" -gt 1 ] || { echo "::error::No mod is installed."; exit 1; }

missing=0
for mod in "${MODS[@]}"; do
    if ! grep -qiE "$(printf '%s' "$mod" | sed 's/[.[\*^$()+?{|]/\\&/g').*(loaded|enabled)|(loaded|enabled).*$(printf '%s' "$mod" | sed 's/[.[\*^$()+?{|]/\\&/g')" <<<"$LOG"; then
        echo "::error::The log does not show that $mod was loaded."
        missing=1
    fi
done

if grep -E '\b(ERROR|FATAL)\b|[Ff]ailed to load' <<<"$LOG"; then
    echo "::error::The log reports errors."
    missing=1
fi

exit "$missing"

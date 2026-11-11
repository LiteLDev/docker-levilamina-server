#! /usr/bin/env bash
# Smoke test of the wine image: install LeviLamina and the packages of test/packages.txt into a new
# volume, start the server, check that every package is installed and every mod is loaded, that the
# server answers on UDP 19132 and reads its console from standard input, that `docker stop` stops it
# cleanly, and that a second start reuses the installation.
#
# Usage: test/smoke-wine.sh <image>

set -euo pipefail

IMAGE="$1"
NAME="levilamina-smoke-$$"
VOLUME="$NAME"
DIR="$(cd "$(dirname "$0")" && pwd)"
WORK="$(mktemp -d)"
INSTALL_TIMEOUT=2400
START_TIMEOUT=600

mapfile -t PACKAGES < <(grep -v '^\s*\(#\|$\)' "$DIR/packages.txt")

cleanup() {
    status=$?
    exec 3>&- || true
    if [ "$status" -ne 0 ]; then
        echo "::group::Container log"
        docker logs "$NAME" 2>&1 || true
        echo "::endgroup::"
    fi
    docker rm -f "$NAME" >/dev/null 2>&1 || true
    docker volume rm -f "$VOLUME" >/dev/null 2>&1 || true
    rm -rf "$WORK"
    exit "$status"
}
trap cleanup EXIT

fail() {
    echo "::error::$*"
    exit 1
}

# Waits until the container log has had $1 lines matching $2, failing after $3 seconds or when the
# container stops.
wait_for_log() {
    local count="$1" pattern="$2" timeout="$3" start=$SECONDS
    while [ "$(docker logs "$NAME" 2>&1 | grep -cE -- "$pattern" || true)" -lt "$count" ]; do
        if [ "$(docker inspect -f '{{.State.Running}}' "$NAME")" != true ]; then
            fail "The container stopped before its log showed /$pattern/ (exit code $(docker inspect -f '{{.State.ExitCode}}' "$NAME"))."
        fi
        if [ $((SECONDS - start)) -ge "$timeout" ]; then
            fail "The log did not show /$pattern/ within $timeout s."
        fi
        sleep 5
    done
}

# The console of the server is the standard input of the container, fed through a FIFO that this
# script keeps open.
mkfifo "$WORK/console"
exec 3<>"$WORK/console"

echo "::group::First start: install and run"
docker volume create "$VOLUME" >/dev/null
docker run -i --name "$NAME" \
    -e EULA=TRUE \
    -e PACKAGES="${PACKAGES[*]}" \
    -p 127.0.0.1:19132:19132/udp \
    -v "$VOLUME:/data" \
    "$IMAGE" <&3 >/dev/null 2>&1 &
wait_for_log 1 'Server started\.' "$INSTALL_TIMEOUT"
echo "::endgroup::"

echo "::group::Installed packages"
LIST="$(docker exec "$NAME" lip list --json)"
echo "$LIST"
for package in github.com/LiteLDev/LeviLamina "${PACKAGES[@]}"; do
    python3 -c 'import json, sys
installed = json.loads(sys.argv[1])["ExplicitInstalled"]
sys.exit(0 if any(p.lower().startswith(sys.argv[2].lower() + "@") for p in installed) else 1)' "$LIST" "$package" \
        || fail "$package is not explicitly installed."
done
echo "::endgroup::"

echo "::group::Loaded mods"
"$DIR/check-mods.sh" "$NAME"
echo "::endgroup::"

echo "::group::Network"
python3 "$DIR/raknet_ping.py" 127.0.0.1 19132 60 || fail "The server does not answer on UDP 19132."
echo "::endgroup::"

echo "::group::Console"
echo "list" >&3
wait_for_log 1 'players online' 60
echo "::endgroup::"

echo "::group::Stop"
docker stop -t 120 "$NAME" >/dev/null
EXIT_CODE="$(docker inspect -f '{{.State.ExitCode}}' "$NAME")"
[ "$EXIT_CODE" = 0 ] || fail "The container exited with code $EXIT_CODE after docker stop."
docker logs "$NAME" 2>&1 | grep -q 'Quit correctly' || fail "The server did not quit correctly after docker stop."
echo "::endgroup::"

echo "::group::Second start: reuse the installation"
docker start "$NAME" >/dev/null
wait_for_log 2 'Server started\.' "$START_TIMEOUT"
"$DIR/check-mods.sh" "$NAME"
python3 "$DIR/raknet_ping.py" 127.0.0.1 19132 60 || fail "The server does not answer on UDP 19132 after a restart."
docker stop -t 120 "$NAME" >/dev/null
EXIT_CODE="$(docker inspect -f '{{.State.ExitCode}}' "$NAME")"
[ "$EXIT_CODE" = 0 ] || fail "The container exited with code $EXIT_CODE after the second docker stop."
[ "$(docker logs "$NAME" 2>&1 | grep -c 'Quit correctly')" -ge 2 ] || fail "The server did not quit correctly after the second docker stop."
echo "::endgroup::"

echo "::group::Container log"
docker logs "$NAME" 2>&1
echo "::endgroup::"

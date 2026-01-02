#!/bin/sh
set -eu

cleanup() {
  if [ -n "${GUACD_PID:-}" ]; then
    kill "$GUACD_PID" 2>/dev/null || true
    wait "$GUACD_PID" 2>/dev/null || true
  fi
}

trap cleanup EXIT TERM INT

mkdir -p /usr/local/next-terminal/data/sqlite \
  /usr/local/next-terminal/data/recording \
  /usr/local/next-terminal/data/drive \
  /var/run

guacd -f /etc/guacamole/guacd.conf &
GUACD_PID=$!

cd /usr/local/next-terminal

if [ "$#" -eq 0 ]; then
  set -- "./next-terminal"
fi

exec "$@"


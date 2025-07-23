#!/bin/sh

FORWARD_RULES="${FORWARD_RULES:-}"

if [ -n "$FORWARD_RULES" ]; then
  IFS=';' read -ra RULES <<< "$FORWARD_RULES"
  for rule in "${RULES[@]}"; do
    SRC_PORT=$(echo "$rule" | cut -d':' -f1)
    DST_HOST=$(echo "$rule" | cut -d':' -f2)
    DST_PORT=$(echo "$rule" | cut -d':' -f3)
    if [ -n "$SRC_PORT" ] && [ -n "$DST_HOST" ] && [ -n "$DST_PORT" ]; then
      echo "Starting socat to forward 0.0.0.0:${SRC_PORT} -> ${DST_HOST}:${DST_PORT}"
      socat TCP-LISTEN:${SRC_PORT},fork TCP:${DST_HOST}:${DST_PORT} &
    fi
  done
fi

exec "$@"

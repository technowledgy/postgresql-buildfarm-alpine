#!/usr/bin/env sh
set -e

if [ -n "$SECRET" ]; then
  docker run --rm \
    -e ANIMAL=basilisk \
    -e SECRET="$SECRET" \
    --entrypoint "" \
    "$(docker build -q .)" \
      ./setnotes.pl \
      --config autoconf.conf \
      "$@"
fi

#!/usr/bin/env sh
set -e

if [ -n "$SECRET" ]; then
  docker run --rm \
    -e ANIMAL=dogfish \
    -e SECRET="$SECRET" \
    --entrypoint "" \
    "$(docker build -q .)" \
      ./setnotes.pl \
      --config meson.conf \
      "$@"
fi

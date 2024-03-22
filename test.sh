#!/usr/bin/env sh
set -eu

# Run this script to test the Dockerfile locally.

docker build .

mkdir -p buildroot
docker run --rm \
  -v ./buildroot:/home/alpine \
  -u "$(id -u):$(id -g)" \
  "$(docker build -q .)" \
    --test \
    --config autoconf.conf \
    --delay-check \
    "$@"
    # TODO: Remove --delay-check once this is fixed:
    # https://www.postgresql.org/message-id/flat/fddd1cd6-dc16-40a2-9eb5-d7fef2101488%40technowledgy.de

#!/usr/bin/env sh
set -eu

# Run this script to test the Dockerfile locally.

docker build .

rm -rf source
git clone --depth 1 https://github.com/postgres/postgres.git source

mkdir -p build
docker run --rm \
  -v ./build:/mnt/build \
  -v ./source:/mnt/source \
  -u "$(id -u):$(id -g)" \
  "$(docker build -q .)" \
    --test \
    --from-source /mnt/source \
    --config autoconf.conf \
    --skip-steps=recovery-check \
    --skip-suites=recovery \
    --delay-check \
    "$@"
    # TODO: Remove --delay-check once this is fixed:
    # https://www.postgresql.org/message-id/flat/fddd1cd6-dc16-40a2-9eb5-d7fef2101488%40technowledgy.de

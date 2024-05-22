#!/usr/bin/env sh
set -e

# This script is run to update the OS and Compiler versions automatically.
# It depends on the server-side making those requests idempotent.
# This runs inside the docker container.

. /etc/os-release
OS_VERSION="$VERSION_ID"
COMPILER_VERSION="$(gcc -dumpfullversion)"

echo "OS: $OS_VERSION"
echo "Compiler: $COMPILER_VERSION"

if [ -n "$SECRET" ]; then
  ./update_personality.pl \
    --os-version="$OS_VERSION" \
    --compiler-version="$COMPILER_VERSION" \
    "$@"
fi

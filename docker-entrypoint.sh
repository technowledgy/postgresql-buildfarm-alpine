#!/usr/bin/env sh
set -eu

# This script fakes passwd/group files via nss_wrapper to satisfy
# initdb's requirement of having a user with a name. We do this,
# because the uid/gid passed from outside are not known in advance.
# Thus we can't create the corresponding users/groups beforehand.

LD_PRELOAD="/usr/lib/libnss_wrapper.so"
NSS_WRAPPER_PASSWD="$(mktemp)"
NSS_WRAPPER_GROUP="$(mktemp)"

uid="$(id -u)"
gid="$(id -g)"

printf 'postgres:x:%s:%s::/buildroot:/bin/false\n' "$uid" "$gid" > "$NSS_WRAPPER_PASSWD"
printf 'postgres:x:%s:\n' "$gid" > "$NSS_WRAPPER_GROUP"

export LD_PRELOAD NSS_WRAPPER_PASSWD NSS_WRAPPER_GROUP

exec /usr/src/run_build.pl "$@"

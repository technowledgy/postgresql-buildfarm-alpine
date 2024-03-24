FROM library/alpine:3.19.1@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b

SHELL ["/bin/sh", "-eux", "-c"]

RUN apk add \
        --no-cache \
        bison \
        build-base \
        ccache \
        clang17 \
        flex \
        git \
        krb5 \
        krb5-dev \
        krb5-server \
        libedit-dev \
        libxml2-dev \
        libxslt-dev \
        linux-headers \
        linux-pam-dev \
        llvm17-dev \
        lz4-dev \
        meson \
        ninja \
        nss_wrapper \
        openldap-dev \
        openssl \
        openssl-dev \
        ossp-uuid-dev \
        perl \
        perl-dev \
        perl-ipc-run \
        perl-lwp-protocol-https \
        perl-mozilla-ca \
        python3-dev \
        tcl-dev \
        zlib-dev \
        zstd-dev

# renovate: datasource=github-tags depName=buildfarm-client lookupName=PGBuildFarm/client-code versioning=redhat extractVersion=REL_(?<version>.*)
ARG BUILDFARM_CLIENT_VERSION=REL_17

RUN git clone --depth 1 --branch ${BUILDFARM_CLIENT_VERSION} https://github.com/PGBuildFarm/client-code /usr/src

WORKDIR /usr/src

# TODO: Upstream this patch to PGBuildFarm/client-code
COPY client.patch .
RUN git apply client.patch

COPY docker-entrypoint.sh /
COPY *.conf /usr/src

ENTRYPOINT ["/docker-entrypoint.sh"]
# TODO: Remove --delay-check once this is fixed:
# https://www.postgresql.org/message-id/flat/fddd1cd6-dc16-40a2-9eb5-d7fef2101488%40technowledgy.de
CMD [ \
  "--test", \
  "--config", \
  "autoconf.conf", \
  "--skip-steps=recovery-check", \
  "--skip-suites=recovery", \
  "--delay-check" \
]

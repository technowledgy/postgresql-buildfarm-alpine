FROM library/alpine:3.20.0@sha256:77726ef6b57ddf65bb551896826ec38bc3e53f75cdde31354fbffb4f25238ebd

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
        openldap \
        openldap-clients \
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
        tini \
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
COPY update.sh /usr/src

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD ["--test", "--config", "autoconf.conf"]

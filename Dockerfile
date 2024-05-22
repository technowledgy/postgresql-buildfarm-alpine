FROM library/alpine:3.20.0@sha256:f08d666161afe0114ee8e925b254456eb79e2ece8a52d7a8979199bfd4fc3ed2

SHELL ["/bin/sh", "-eux", "-c"]

RUN apk add \
        --no-cache \
        bison \
        build-base \
        ccache \
        clang18 \
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
        llvm18-dev \
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

ENV CLANG=/usr/lib/llvm18/bin/clang
ENV LLVM_CONFIG=/usr/lib/llvm18/bin/llvm-config

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

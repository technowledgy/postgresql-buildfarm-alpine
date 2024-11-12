FROM library/alpine:3.20.3@sha256:1e42bbe2508154c9126d48c2b8a75420c3544343bf86fd041fb7527e017a4b4a

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
ARG BUILDFARM_CLIENT_VERSION=18

RUN git clone --depth 1 --branch REL_${BUILDFARM_CLIENT_VERSION} https://github.com/PGBuildFarm/client-code /usr/src

WORKDIR /usr/src

COPY docker-entrypoint.sh /
COPY *.conf /usr/src
COPY update.sh /usr/src

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD ["--test", "--config", "autoconf.conf"]

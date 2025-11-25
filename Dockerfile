FROM library/alpine:3.22.2@sha256:4b7ce07002c69e8f3d704a9c5d6fd3053be500b7f1c69fc0d80990c2ad8dd412

SHELL ["/bin/sh", "-eux", "-c"]

RUN apk add \
        --no-cache \
        bison \
        build-base \
        ccache \
        clang20 \
        curl-dev \
        flex \
        gettext-tiny-dev \
        git \
        krb5 \
        krb5-dev \
        krb5-server \
        libedit-dev \
        liburing-dev \
        libxml2-dev \
        libxslt-dev \
        linux-headers \
        linux-pam-dev \
        llvm20-dev \
        lz4-dev \
        meson \
        ninja \
        numactl-dev \
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

ENV CLANG=/usr/lib/llvm20/bin/clang
ENV LLVM_CONFIG=/usr/lib/llvm20/bin/llvm-config

# renovate: datasource=github-tags depName=buildfarm-client lookupName=PGBuildFarm/client-code versioning=regex:^(?<major>\d+)(_(?<minor>\d+))?$ extractVersion=REL_(?<version>.*)
ARG BUILDFARM_CLIENT_VERSION=20

RUN git clone --depth 1 --branch REL_${BUILDFARM_CLIENT_VERSION} https://github.com/PGBuildFarm/client-code /usr/src

WORKDIR /usr/src

COPY docker-entrypoint.sh /
COPY *.conf /usr/src
COPY update.sh /usr/src

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD ["--test", "--config", "autoconf.conf"]

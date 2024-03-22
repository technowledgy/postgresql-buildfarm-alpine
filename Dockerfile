FROM library/alpine:3.19.1@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b

SHELL ["/bin/sh", "-eux", "-c"]

RUN addgroup -g 1000 alpine \
  ; adduser -u 1000 alpine -G alpine -D \
  ; apk add \
        --no-cache \
        bison \
        build-base \
        ccache \
        flex \
        git \
        krb5-dev \
        # TODO: Make meson find this instead of readline \
        #libedit-dev \
        libxml2-dev \
        libxslt-dev \
        linux-headers \
        openldap-dev \
        openssl-dev \
        perl \
        perl-dev \
        perl-lwp-protocol-https \
        perl-mozilla-ca \
        python3-dev \
        readline-dev \
        tcl-dev \
        zlib-dev

ARG BUILDFARM_CLIENT_VERSION=REL_17

RUN git clone --depth 1 --branch ${BUILDFARM_CLIENT_VERSION} https://github.com/PGBuildFarm/client-code /usr/src

COPY *.conf /usr/src

USER alpine
WORKDIR /home/alpine
VOLUME /home/alpine

ENTRYPOINT ["/usr/src/run_build.pl"]
# TODO: Remove --delay-check once this is fixed:
# https://www.postgresql.org/message-id/flat/fddd1cd6-dc16-40a2-9eb5-d7fef2101488%40technowledgy.de
CMD ["--test", "--config", "autoconf.conf", "--delay-check"]

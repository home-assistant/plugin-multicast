# Base image updated by Renovate, update versionCompatibility on Alpine base bump
FROM ghcr.io/home-assistant/base:3.24-2026.10.1@sha256:992dc6a5727b97a30da8dd259b489739299c324407557df540165e2f0dbb7763

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

# Everything in this image runs s6-supervised and is stopped gracefully
# by s6-rc: skip the blind SIGTERM-to-SIGKILL grace sleep at shutdown.
ENV S6_KILL_GRACETIME=0

ARG MDNS_REPEATER_VERSION="1.2.0"

RUN \
    apk add --no-cache --virtual .build-deps \
        build-base \
        git \
    \
    && git clone -b ${MDNS_REPEATER_VERSION} --depth 1 \
        https://github.com/pvizeli/mdns-repeater /usr/src/mdns \
    && cd /usr/src/mdns \
    && gcc -O3 -o /usr/bin/mdns-repeater \
        mdns-repeater.c -DVERSION="\"${MDNS_REPEATER_VERSION}\"" \
    \
    && apk del .build-deps \
    && rm -rf \
        /usr/src/mdns

COPY rootfs /

LABEL \
    io.hass.type="multicast" \
    org.opencontainers.image.title="Home Assistant Multicast Plugin" \
    org.opencontainers.image.description="Home Assistant Supervisor plugin for Multicast" \
    org.opencontainers.image.authors="The Home Assistant Authors" \
    org.opencontainers.image.url="https://www.home-assistant.io/" \
    org.opencontainers.image.documentation="https://www.home-assistant.io/docs/" \
    org.opencontainers.image.licenses="Apache License 2.0"

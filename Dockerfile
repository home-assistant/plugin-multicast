ARG BUILD_FROM
FROM ${BUILD_FROM}

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

RUN \
    apk add --no-cache --virtual .build-deps \
        build-base \
        git \
        linux-headers

ARG MDNS_REPEATER_VERSION
RUN \
    git clone -b ${MDNS_REPEATER_VERSION} --depth 1 \
        https://github.com/pvizeli/mdns-repeater /usr/src/mdns \
    && cd /usr/src/mdns \
    && gcc -O3 -o /usr/bin/mdns-repeater \
        mdns-repeater.c -DVERSION="\"${MDNS_REPEATER_VERSION}\"" \
    && rm -rf \
        /usr/src/mdns

ARG PIMD_VERSION
RUN \
    git clone -b ${PIMD_VERSION} --depth 1 \
        https://github.com/troglobit/pimd /usr/src/pimd \
    && cd /usr/src/pimd \
    && ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var \
    && make \
    && cp -av ./pimd /usr/bin/ \
    && rm -rf /usr/src/pimd

RUN \
    apk del .build-deps

COPY rootfs /

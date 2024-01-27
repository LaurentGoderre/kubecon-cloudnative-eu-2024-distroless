FROM alpine:3.18

RUN set -ex; \
    apk update; \
    apk add \
        bash \
        jq; \
    mkdir /build;

COPY build.sh /usr/bin/build

VOLUME /build
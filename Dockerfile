ARG BASETAG=latest
FROM alpine:$BASETAG
ARG TARGETARCH=amd64
ARG TARGETOS=linux

LABEL maintainer="Akhil R S <hello@ars.vg>"

RUN apk update \
    apk add --no-cache postgresql-client
    
CMD ["/bin/sh", "-c", "while sleep 60; do echo '.'; done"]
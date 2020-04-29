#FROM docker
FROM alpine:3

ENV SLEEP_TIME='10m'
ENV FILTER_SERVICES=''

RUN apk add --no-cache docker bash

#RUN apk add --update --no-cache bash curl

COPY shepherd /usr/local/bin/shepherd

ENTRYPOINT ["/usr/local/bin/shepherd"]

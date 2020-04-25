FROM docker

ENV SLEEP_TIME='10m'
ENV FILTER_SERVICES=''

RUN apk add --update --no-cache bash curl

COPY shepherd /usr/local/bin/shepherd

ENTRYPOINT ["/usr/local/bin/shepherd"]

FROM docker

RUN apk add --update --no-cache bash

COPY shepherd /usr/local/bin/shepherd

ENTRYPOINT ["/usr/local/bin/shepherd"]

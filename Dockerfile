FROM docker

RUN apk add --update --no-cache bash tzdata

RUN echo "EST" > /etc/timezone

COPY shepherd /usr/local/bin/shepherd

ENTRYPOINT ["/usr/local/bin/shepherd"]

# Shepherd

[![Build Status](https://travis-ci.com/jnk5y/shepherd.svg?branch=master)](https://travis-ci.com/jnk5y/shepherd)
[![Docker Stars](https://img.shields.io/docker/stars/jnk5y/shepherd.svg)](https://hub.docker.com/r/jnk5y/shepherd/)
[![Docker Pulls](https://img.shields.io/docker/pulls/jnk5y/shepherd.svg)](https://hub.docker.com/r/jnk5y/shepherd/)

A Docker swarm service for automatically updating your services every x minutes by running docker service update. I reduced default logging and added a verbose environment variable to allow for more logging statements. I also added timestamps to the logs and added a timezone environment variable to set the container's timezone.

## Usage
    docker service create --name shepherd \
                          --constraint "node.role==manager" \
                          --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock,ro \
                          jnk5y/shepherd

## Or with docker-compose
    version: "3"
    services:
      app:
        image: jnk5y/shepherd
        volumes:
          - /var/run/docker.sock:/var/run/docker.sock
        deploy:
          placement:
            constraints:
            - node.role == manager
        environment:
          TZ: 'US/Eastern'
          SLEEP_TIME: '10m'
          FILTER_SERVICES: ''
          VERBOSE: 'false'

## Or with docker stack - This allows shepherd to update itself
    docker stack deploy --compose-file docker-compose.yml shepherd

### Configuration

Shepherd will try to update your services every 10 minutes by default. You can adjust this value using the `SLEEP_TIME` variable.

You can prevent services from being updated by appending them to the `BLACKLIST_SERVICES` variable. This should be a space-separated list of service names.

Alternatively you can specify a filter for the services you want updated using the `FILTER_SERVICES` variable. This can be anything accepted by the filtering flag in `docker service ls`.

You can enable private registry authentication by setting the `WITH_REGISTRY_AUTH` variable.

## How does it work?

Shepherd just triggers updates by updating the image specification for each service, removing the current digest.

Most of the work is thankfully done by Docker which [resolves the image tag, checks the registry for a newer version and updates running container tasks as needed](https://docs.docker.com/engine/swarm/services/#update-a-services-image-after-creation).

Also, Docker handles all the work of [applying rolling updates](https://docs.docker.com/engine/swarm/swarm-tutorial/rolling-update/). So at least with replicated services, there should be no noticeable downtime.

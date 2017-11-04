#!/bin/bash
# Runs the Interop Server in a container. Makes the server IP be 10.10.130.2.

#NOTE:: Modified by Kennon to make it have an ip address that matches this page: https://auvsi-suas-competition-interoperability-system.readthedocs.io/en/latest/getting_started.html
docker network create --subnet 10.10.130.0/24 serverNet
docker run -d --net serverNet --ip 10.10.130.2 --restart=unless-stopped --interactive --tty --publish 8000:80 --name interop-server auvsisuas/interop-server

# Poll server up to 2 min for healthiness before proceeding.
for i in {1..120};
do
    docker inspect -f "{{.State.Health.Status}}" interop-server | grep "^healthy$" && exit 0 || sleep 1;
done

exit 1

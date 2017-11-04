#!/bin/bash
# Runs the Interop Server in a container. Makes the server IP be 10.10.130.2.

#NOTE:: Modified by Kennon to make it have an ip address that matches this page: https://auvsi-suas-competition-interoperability-system.readthedocs.io/en/latest/getting_started.html
docker network create --subnet 192.168.1.0/24 Test192Net
docker run -d --net Test192Net --ip 192.168.1.56 --restart=unless-stopped --interactive --tty --publish 8000:80 --name interop-server auvsisuas/interop-server
# Poll server up to 2 min for healthiness before proceeding.
for i in {1..120};
do
    docker inspect -f "{{.State.Health.Status}}" interop-server | grep "^healthy$" && exit 0 || sleep 1;
done

exit 1

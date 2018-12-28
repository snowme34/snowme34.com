# Docker Commands

*Last Update: 12/12/2018.*

* [Docker Docs Get Started](https://docs.docker.com/get-started)

* [Official Docker Commandline Reference](https://docs.docker.com/engine/reference/commandline/docker/)

## Install

* [Install docker for Debian](https://docs.docker.com/install/linux/docker-ce/debian)

Install docker using a script

```bash
curl -sSL https://get.docker.com/ | sh
```

* [Install docker-compose](https://docs.docker.com/compose/install/#install-compose)

## Post-Install

* [Post-installation steps for Linux](https://docs.docker.com/install/linux/linux-postinstall/)

* [Compose file version 3 reference](https://docs.docker.com/compose/compose-file/)

## Basic

```bash
docker info

docker image ls
docker images
docker image rm
docker image rm $(docker image ls -a -q) # remove all images
docker rmi

docker pull

docker container ls --all -aq

docker stat
```

## Run

* [Correct way to detach from a container without stopping it](https://stackoverflow.com/questions/25267372/correct-way-to-detach-from-a-container-without-stopping-it)

```bash
docker exec -it <some-container> <some-command>
```

## Docker Compose

```bash
docker run -it -u 1001:1001 -v /home/user/docker-volumes/00:/external-volume --name some-name some/repo
docker run -d -p 80:80 some-image
# after run, docker created a container using that image, images themselves did not change
docker container ls
docker container stop

# https://stackoverflow.com/questions/27380641/see-full-command-of-running-stopped-container-in-docker
docker ps -a --no-trunc

# for containers
docker ps -a
docker ps -l
docker start
docker stop
docker rm
docker container rm $(docker container ls -a -q) # reomve all conatiners
```

## Hub

```bash
docker commit -m "some message" -a "some author" <some-reference> some-user/some-repo

docker login -u <some-docker-user-name>
docker tag local-user-name/some-repo some-docker-user-name/some-repo
docker push some-docker-user-name/some-repo
docker run -p 8081:80 some-docker-user-name/some-repo:some-tag
```

## service and swarm

```bash
## deploy
docker swarm init --advertise-addr <some-ip-address>
docker join
docker stack deploy -c docker-compose.yml <some-app-name>
## inspect
docker inspect <some-task>
docker inspect <some-container>
docker stack ls
docker service ls
docker service ps <some-service>
docker container ls -q # only ids
## quit
docker stack rm <some-app-name>
docker swarm leave --force
## logs
docker service logs <some-task>
```

More about `swarm`

* [Docker Machine](https://docs.docker.com/get-started/part4/)

```bash
docker-machine --debug create -d "virtualbox" default
```

## secret

```bash
docker secret create some-secret -
```

## network

```bash
docker network create -d bridge <some-network>
```

## volume

```bash
docker volume inspect <some-volume>
```
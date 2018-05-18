#!/usr/bin/env bash
#*******************************************************************************
# This Vitam docker demo is a container to launch Vitam in a small environment
# to make simple tasks
# You need:
#    - a linux OS with at least 8 MB of RAM (CentOS or Debian)
#    - docker installed: if not go to https://get.docker.com/
# Instructions:
#    - Copy this run.sh file
#    - Make it executable: sudo chmod +x run.sh
#    - Launch it: ./run.sh
#    - Inside the container
#	- The first time, you need to deploy all the components with the command 'vitam-deploy-all'
#       - To start, you type: 'vitam-start'
#       - Launch your browser at the adress http://localhost
#       - When you relaunch the container, you don't need to redeploy, you have just to type 'vitam-start'
# 
#
# Vitam is a French program, for more information: www.programmevitam.fr
# If you have any question, ask me: fdeguilhen@gmail.com
#*******************************************************************************

## Test if docker is installed
docker --version | grep "Docker version"
if (( ${?} != 0 )); then
	echo "Docker is not installed. Install docker (https://get.docker.com/) and try again."
	exit 1
fi

echo "Launching Vitam demo docker"

VITAMDEV_USER=${LOGNAME}
VITAMDEV_IMAGE=fdeguilhen/docker-vitam-demo-1.0
VITAMDEV_CONTAINER=vitam-docdemo-ctner

VITAMDEV_USER_UID=$(id -u ${VITAMDEV_USER})
VITAMDEV_USER_GID=$(id -g ${VITAMDEV_USER})

MAPPING_PORTS="-p 80:80 -p 8082:8082 -p 9102:9102 -p 9104:9104 -p 9200:9200 -p 9201:9201 -p 9300:9300 -p 9301:9301 -p 9000:9000 -p 9002:9002 -p 9900:9900 -p 27016:27016 -p 27017:27017 -p 10514:10514 -p 8000-8010:8000-8010 -p 8100-8110:8100-8110 -p 8200-8210:8200-8210 -p 8090:8090 -p 8300-8310:8300-8310 -p 5601:5601 -p 8500:8500 -p 8443-8446:8443-8446"


if [ -z "$(docker ps -a | grep ${VITAMDEV_CONTAINER})" ]; then

	echo "Launching docker container as daemon (launching systemd init process...)"

	docker run -d --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro ${MAPPING_PORTS} --cap-add=SYS_ADMIN --security-opt seccomp=unconfined --name=${VITAMDEV_CONTAINER} --net=bridge --dns=127.0.0.1 --dns=10.100.211.222 --dns=8.8.8.8 ${VITAMDEV_IMAGE}

	if (( ${?} != 0 )); then
		echo "Container refused to start please correct and retry"
		docker rm ${VITAMDEV_CONTAINER}
		exit 1
	fi
	echo "Registering user ${VITAMDEV_USER} in container..."
	docker exec ${VITAMDEV_CONTAINER} groupadd -g ${VITAMDEV_USER_GID} vitam-dev

	docker exec ${VITAMDEV_CONTAINER} useradd -u ${VITAMDEV_USER_UID} -g ${VITAMDEV_USER_GID} -G wheel \
		-d /devhome -s /bin/bash -c "Welcome, " ${VITAMDEV_USER}

	echo "Your container is now configured ; to reuse it, just relaunch this script."

else
	echo "Starting existing container; please wait..."
	docker start ${VITAMDEV_CONTAINER}
fi

echo "Opening console..."
docker exec -it -u ${VITAMDEV_USER} ${VITAMDEV_CONTAINER} bash
echo "Stopping container..."
docker stop ${VITAMDEV_CONTAINER}
echo "Container stopped !"
echo "Hint : your container is now stopped, but not removed ; it will be used the next time you use this command."
echo "To restart from scratch, run 'docker rm ${VITAMDEV_CONTAINER}' to remove the existing container."

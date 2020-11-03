#/bin/bash
echo "Currently running containers..."
docker ps -aq
echo "Stopping and removing all containers..."
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

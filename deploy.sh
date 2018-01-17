#!/bin/bash

# $1    -> name of the image
# $2    -> path to project
# $3    -> branch to deploy
# $4    -> docker app file
# $5..  -> docker arguments

cd $2

# There is possibly another deploy in progress, wait for lock
lockname="deploy_lock"
/home/ubuntu/nodock/wait_lock.sh ${lockname}
touch ${lockname}

git fetch --all
git fetch --tags
git branch deploy
git checkout deploy
git reset $3 --hard

sudo docker kill $1-container
sudo docker rm $1-container

sudo docker rmi $1-app

sudo docker build -t $1-app -f $4 .
rm ${lockname}

# The script never ends because it starts a server...removing the lock just before the docker
# is ran should be enough to prevent some major inconsistency.
sudo docker run "${@:5}" $1-app

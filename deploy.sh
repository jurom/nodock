#!/bin/bash

# $1    -> name of the image
# $2    -> path to project
# $3    -> branch to deploy
# $4    -> docker app file
# $5..  -> docker arguments

cd $2

git fetch --all
git branch deploy
git checkout deploy
git reset $3 --hard

sudo docker kill $1-container
sudo docker rm $1-container

sudo docker rmi $1-app

sudo docker build -t $1-app -f $4 .
sudo docker run "${@:5}" $1-app

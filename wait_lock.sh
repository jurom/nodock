#!/bin/bash
echo "Checking for lock ${1}"
if [ -f ${1} ]
then
  echo -n "Waiting for lock"
fi
while [ -f ${1} ]
do
  echo -n "."
  sleep 2
done
echo "Lock acquired"

#!/bin/bash

REPOSITORY=$1
VERSION=$2
CONTAINER_NAME=$3

cd $(dirname $0)/..

PROJECT_NAME=$(basename `pwd`)

: ${REPOSITORY:=${PROJECT_NAME}}
: ${VERSION:=`cat version`}
: ${CONTAINER_NAME:=${PROJECT_NAME}}

set -x

# Run container to test
docker run -d --name=${CONTAINER_NAME} ${REPOSITORY}:${VERSION}

sleep 45

test="`docker exec -i ${CONTAINER_NAME} curl -i 127.0.0.1:8081 &> /dev/null; echo $?`"

# Clean container
docker stop ${CONTAINER_NAME}
docker rm ${CONTAINER_NAME}

exit $test

#!/bin/bash

ORGANIZATION=$ORGANIZATION
ACCESS_TOKEN=$ACCESS_TOKEN

cd /home/docker/actions-runner

./config.sh --unattended --url https://github.com/${ORGANIZATION} --token ${ACCESS_TOKEN} --labels dev-server

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${ACCESS_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!

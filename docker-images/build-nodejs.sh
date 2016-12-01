#!/bin/bash

set -e

for image in \
        docker-images/nodejs \
    ; do
        docker build -t ${image} ./${image}
    done

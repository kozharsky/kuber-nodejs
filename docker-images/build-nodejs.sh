#!/bin/bash

set -e

for image in \
        nodejs \
    ; do
        docker build -t ${image} ./${image}
    done

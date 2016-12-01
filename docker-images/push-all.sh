#!/bin/bash

set -e

eval $(aws ecr get-login --region ${REGION})

for image in \
        docker-images/nodejs \
    ; do
        ECR_TAG="${ECR_REPO}/${image}:latest"
        docker tag "${image}:latest" "${ECR_TAG}"
        docker push "${ECR_TAG}"
    done
#!/bin/bash
set -e

for i in "$@"
do
case $i in
    --stack-name=*)
    STACK_NAME=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
    ;;
    --pod=*)
    POD=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
    ;;
    --version=*)
    VERSION=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
    ;;
    *)
    echo "Unknown option ${i}"
    ;;
esac
done

eval $(aws ecr get-login --region ${REGION})

echo "Updating ${POD} $STACK_NAME, builded version ${VERSION}"
docker build -t ${POD}:${VERSION} ./docker-images/${POD}

ECR_TAG="${ECR_REPO}/${POD}:${VERSION}"

docker tag "${POD}:${VERSION}" "${ECR_TAG}"
docker push "${ECR_TAG}"
echo "ECR = ${ECR_TAG}"
${kubectl} set image deployment/${STACK_NAME}-${POD} ${STACK_NAME}-${POD}=${ECR_TAG}
echo "/usr/local/bin/kubectl set image deployment/${STACK_NAME}-${POD} ${STACK_NAME}-${POD}=${ECR_TAG}"

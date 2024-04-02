#!/bin/bash

AWS_REGION=ap-northeast-1
AWS_ACCOUNT_ID=573320755782
CONTAINER_NAME=ddd-study
REPO_NAME=ddd-study-dev-ecr
DOCKER_DIR=.
REPO_URL=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME

# Docker login
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Build image
export CONTAINER_NAME=$CONTAINER_NAME
docker buildx build --platform=linux/amd64 -t $CONTAINER_NAME $DOCKER_DIR
# docker-compose -f $DOCKER_DIR build --no-cache

# Tag
docker tag $CONTAINER_NAME:latest $REPO_URL:latest

# Push image
docker push $REPO_URL:latest



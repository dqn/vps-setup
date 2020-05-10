#!/bin/bash

# Example for Go

eval "$(cat ./deploy/.env <(echo) <(declare -x))"

GOOS=linux GOARCH=amd64 go build -ldflags "-s -w"
scp -P ${PORT} example ${USER_NAME}@${HOST}:/home/${USER_NAME}/
ssh -t ${USER_NAME}@${HOST} -p ${PORT} "sudo systemctl restart example.service"

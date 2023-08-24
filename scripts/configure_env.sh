#!/bin/bash

environment="$1"

if [ -z $1 ]; then
	echo "Please pass environment as argument (staging or production)"
	exit 0
elif [ "$environment" != "production" ] && [ "$environment" != "staging" ]; then
	echo "Please pass a valid environment (staging or production)"
	exit 0
else
	cp -rf ../flutter-app-secrets/$environment/* ./ &&
	cp -a ../flutter-app-secrets/$environment/ ./ &&
	source .env
	echo "Done!"
fi
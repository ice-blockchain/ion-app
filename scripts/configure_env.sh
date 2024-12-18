#!/bin/bash

environment="$1"

if [ -z $1 ]; then
	echo "Please pass environment as argument (staging / production / testnet)"
	exit 0
elif [ "$environment" != "production" ] && [ "$environment" != "staging" ] && [ "$environment" != "testnet" ]; then
	echo "Please pass a valid environment (staging / production / testnet)"
	exit 0
else
	cp -rf ../flutter-app-secrets/$environment/* ./ &&
	cp -a ../flutter-app-secrets/$environment/ ./ &&
	source .env
	echo "Done!"
fi
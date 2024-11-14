#!/bin/sh

rm -rf api web

echo 'Cloning repos...'
git clone https://github.com/spec-box/api.git
git clone https://github.com/spec-box/web.git

rm ./web/package-lock.json

export VERSION=1.0.0

echo 'Running docker build'

docker buildx build --push --platform linux/arm64,linux/amd64 --tag specbox/web:$VERSION --tag latest .

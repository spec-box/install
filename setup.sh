#!/bin/sh

echo 'Cloning repos...'
git clone https://github.com/spec-box/api.git
git clone https://github.com/spec-box/web.git
#git clone https://github.com/spec-box/sync.git 
#git clone https://github.com/spec-box/text-parser.git

export VERSION=0.0.1

echo 'Running docker build'
docker build .

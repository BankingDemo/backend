#!/bin/bash -e

cd $(dirname $0)
. ../environment
. utils

./env-setup.sh
./db-deploy.sh
./app-deploy.sh
./app-build.sh

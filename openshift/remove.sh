#!/bin/bash -e

cd $(dirname $0)
. ../environment
. utils

oc delete all -l service=mysql
oc delete all -l service=bankingapplication
oc delete imagestream eap-openshift

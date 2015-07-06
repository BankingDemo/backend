#!/bin/bash -e

cd $(dirname $0)
. ../environment
. utils

oc create -f - <<EOF || true
kind: ImageStream
apiVersion: v1
metadata:
  name: eap-openshift
spec:
  dockerImageRepository: docker.io/bankingdemo/eap-openshift
  tags:
  - name: latest
EOF

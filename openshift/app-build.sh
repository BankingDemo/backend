#!/bin/bash -e

cd $(dirname $0)
. ../environment
. utils

oc create -f - <<EOF || true
kind: ImageStream
apiVersion: v1
metadata:
  name: bankingapplication
  labels:
    service: bankingapplication
EOF

oc create -f - <<EOF
kind: BuildConfig
apiVersion: v1
metadata:
  name: bankingapplication
  labels:
    service: bankingapplication
spec: 
  strategy:
    type: Source
    sourceStrategy:
      from:
        kind: ImageStreamTag
        name: eap-openshift:latest
  source:
    type: Git
    git:
      uri: $GITURL
      ref: master
  output:
    to:
      name: bankingapplication
  triggers:
  - github:
      secret: secret
    type: GitHub
EOF

oc start-build bankingapplication

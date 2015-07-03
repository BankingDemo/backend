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
        namespace: openshift
        name: jboss-eap6-openshift:6.4
  source:
    type: Git
    git:
      uri: $GITURL
      ref: master
  output:
    to:
      name: bankingapplication
EOF

oc start-build bankingapplication

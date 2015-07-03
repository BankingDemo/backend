#!/bin/bash -e

cd $(dirname $0)

. utils

new_env MYSQL_USER bankingapp
new_env MYSQL_PASS $(random)
new_env MYSQL_DATABASE bankingapp

. ../environment

oc create -f - <<EOF
kind: List
apiVersion: v1
items:
- kind: ReplicationController
  apiVersion: v1
  metadata:
    name: mysql
    labels:
      service: mysql
  spec:
    replicas: 1
    selector:
      service: mysql
    template:
      metadata:
        name: mysql
        labels:
          service: mysql
      spec:
        containers:
        - name: mysql
          image: openshift3/mysql-55-rhel7:latest
          ports:
          - containerPort: 3306
          env:
          - name: MYSQL_DATABASE
            value: "$MYSQL_DATABASE"
          - name: MYSQL_USER
            value: "$MYSQL_USER"
          - name: MYSQL_PASSWORD
            value: "$MYSQL_PASS"

- kind: Service
  apiVersion: v1
  metadata:
    name: mysql
    labels:
      service: mysql
  spec:
    ports:
    - port: 3306
    selector:
      service: mysql
EOF

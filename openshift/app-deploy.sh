#!/bin/bash -e

cd $(dirname $0)

. utils

new_env MYSQL_USER bankingapp
new_env MYSQL_PASS $(random)
new_env MYSQL_DATABASE bankingapp

. ../environment

oc create -f - <<EOF || true
kind: ImageStream
apiVersion: v1
metadata:
  name: bankingapplication
  labels:
    service: bankingapplication
EOF

oc create -f - <<EOF
kind: List
apiVersion: v1
items:
- kind: DeploymentConfig
  apiVersion: v1
  metadata:
    name: bankingapplication
    labels:
      service: bankingapplication
  spec:
    strategy:
      type: Recreate
    triggers:
    - type: ConfigChange
    - type: ImageChange
      imageChangeParams:
        automatic: true
        containerNames:
        - bankingapplication
        from:
          kind: ImageStream
          name: bankingapplication
        tag: latest
    replicas: 1
    selector:
      service: bankingapplication
    template:
      metadata:
        name: bankingapplication
        labels:
          service: bankingapplication
      spec:
        containers:
        - name: bankingapplication
          image: bankingapplication:latest
          ports:
          - containerPort: 8778
            name: jolokia
          env:
          - name: JAVA_OPTS
            value: "-server -XX:+UseCompressedOops -verbose:gc -Xloggc:/opt/eap/standalone/log/gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=3M -XX:-TraceClassUnloading -Xms128m -Xmx512m -XX:MaxPermSize=256m -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=org.jboss.logmanager -Djava.awt.headless=true -Djboss.modules.policy-permissions=true -Xbootclasspath/p:/opt/eap/jboss-modules.jar:/opt/eap/modules/system/layers/base/org/jboss/logmanager/main/jboss-logmanager-1.5.4.Final-redhat-1.jar:/opt/eap/modules/system/layers/base/org/jboss/logmanager/ext/main/javax.json-1.0.4.jar:/opt/eap/modules/system/layers/base/org/jboss/logmanager/ext/main/jboss-logmanager-ext-1.0.0.Alpha2-redhat-1.jar -Djava.util.logging.manager=org.jboss.logmanager.LogManager -javaagent:/opt/eap/jolokia.jar=port=8778,host=0.0.0.0,discoveryEnabled=false"
          - name: DB_SERVICE_PREFIX_MAPPING
            value: mysql
          - name: MYSQL_SERVICE_HOST
            value: mysql
          - name: MYSQL_SERVICE_PORT
            value: "3306"
          - name: mysql_JNDI
            value: "java:jboss/datasources/MySqlDS"
          - name: mysql_USERNAME
            value: "$MYSQL_USER"
          - name: mysql_PASSWORD
            value: "$MYSQL_PASS"
          - name: mysql_DATABASE
            value: "$MYSQL_DATABASE"
  
- kind: Service
  apiVersion: v1
  metadata:
    name: bankingapplication
    labels:
      service: bankingapplication
  spec:
    ports:
    - port: 80
      targetPort: 8080
    selector:
      service: bankingapplication

- kind: Route
  apiVersion: v1
  metadata:
    name: bankingapplication
    labels:
      service: bankingapplication
  spec:
    to:
      name: bankingapplication
EOF

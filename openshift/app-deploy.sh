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
          - containerPort: 8080
          env:
          - name: JAVA_OPTS
            value: "-server -XX:+UseCompressedOops -verbose:gc -Xloggc:/opt/eap/standalone/log/gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=3M -XX:-TraceClassUnloading -Xms128m -Xmx512m -XX:MaxPermSize=256m -Djava.net.preferIPv4Stack=true -Djboss.modules.system.pkgs=org.jboss.logmanager -Djava.awt.headless=true -Djboss.modules.policy-permissions=true -Xbootclasspath/p:/opt/eap/jboss-modules.jar:/opt/eap/modules/system/layers/base/org/jboss/logmanager/main/jboss-logmanager-1.5.4.Final-redhat-1.jar:/opt/eap/modules/system/layers/base/org/jboss/logmanager/ext/main/javax.json-1.0.4.jar:/opt/eap/modules/system/layers/base/org/jboss/logmanager/ext/main/jboss-logmanager-ext-1.0.0.Alpha2-redhat-1.jar -Djava.util.logging.manager=org.jboss.logmanager.LogManager -javaagent:/opt/eap/jolokia.jar=port=8778,host=0.0.0.0,discoveryEnabled=false"
          - name: DB_SERVICE_PREFIX_MAPPING
            value: ignore
          - name: datasources
            value: "<datasource jndi-name=\"java:jboss/datasources/MySqlDS\" pool-name=\"MySqlDS\" enabled=\"true\" use-java-context=\"true\"><connection-url>jdbc:mysql://mysql:3306/$MYSQL_DATABASE</connection-url><driver>mysql</driver><security><user-name>$MYSQL_USER</user-name><password>$MYSQL_PASS</password></security></datasource>"
  
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

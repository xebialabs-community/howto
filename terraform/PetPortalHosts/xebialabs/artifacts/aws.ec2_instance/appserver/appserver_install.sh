#!/usr/bin/env bash

export MYSQL_DRIVER_VERSION="mysql-connector-java-5.1.40"
export wildfly_version="12.0.0.Final"

sudo yum -y install mariadb java-1.8.0
#sudo yum -y java install mysql-connector-java

mkdir -p /tmp/downloads
cd /tmp/downloads
curl -LO https://download.jboss.org/wildfly/${wildfly_version}/wildfly-${wildfly_version}.zip
sudo unzip -q /tmp/downloads/wildfly-${wildfly_version}.zip -d /opt
sudo mv /opt/wildfly-* /opt/wildfly
sudo /home/ec2-user/resources/install-mysql-driver.sh
sudo cp ~/resources/mgmt-users.properties /opt/wildfly/standalone/configuration/mgmt-users.properties
sudo cp ~/resources/mgmt-users.properties /opt/wildfly/domain/configuration/mgmt-users.properties
echo "###################################################################################"
#/usr/bin/screen -d -m sudo /opt/wildfly/bin/standalone.sh -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=localhost
nohup sudo /opt/wildfly/bin/standalone.sh -Djboss.bind.address=0.0.0.0 -Djboss.bind.address.management=localhost &
count=0
while true
do
  if [ $count -le 10 ]; then
    echo "Waiting ${count}"
    count=$(( count+1 ))
    sleep 1
  else
    break
  fi
  sleep 1
done
cat <<EOF
###################################################################################
#
#          END
#
#
###################################################################################
EOF
echo "DONE"

#!/usr/bin/env bash

set -x

SCALA_VER=2.11.2
ACTIVATOR_VER=1.3.2
MYSQL_ROOT_PW="cookbook"

if [ ! -e "/home/vagrant/.firstboot" ]; then
  
  # tools etc
  yum -y install yum-plugin-fastestmirror
  yum -y install git wget curl rpm-build
  
  # Pre-docker install: http://stackoverflow.com/a/27216873
  sudo yum-config-manager --enable public_ol6_latest
  sudo yum install -y device-mapper-event-libs

  # Docker 
  yum -y install docker-io
  service docker start
  chkconfig docker on
  usermod -a -G docker vagrant

  # Install the JDK
  curl -LO 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie'
  rpm -i jdk-7u51-linux-x64.rpm
  /usr/sbin/alternatives --install /usr/bin/java java /usr/java/default/bin/java 200000
  rm jdk-7u51-linux-x64.rpm

  # Install scala repl
  rpm -ivh http://scala-lang.org/files/archive/scala-$SCALA_VER.rpm
  
  # Install Activator
  cd /opt
  wget http://downloads.typesafe.com/typesafe-activator/$ACTIVATOR_VER/typesafe-activator-$ACTIVATOR_VER.zip
  unzip typesafe-activator-$ACTIVATOR_VER.zip 
  chown -R vagrant:vagrant /opt/activator-$ACTIVATOR_VER

  # Local time
  mv /etc/localtime /etc/localtime.bak
  ln -s /usr/share/zoneinfo/Asia/Manila /etc/localtime

  # Set Path
  echo "export JAVA_HOME=/usr/java/default/" >> /home/vagrant/.bash_profile
  echo "export PATH=$PATH:$JAVA_HOME/bin:/home/vagrant/bin:/opt/activator-$ACTIVATOR_VER" >> /home/vagrant/.bash_profile
  
  touch /home/vagrant/.firstboot
fi

# Start MySQL
docker run -e MYSQL_PASS=$MYSQL_ROOT_PW -i -d -p 3306:3306 --name mysqld -t tutum/mysql


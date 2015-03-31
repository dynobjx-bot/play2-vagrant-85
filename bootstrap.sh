#!/usr/bin/env bash

set -x

if [ ! -e "/home/vagrant/.firstboot" ]; then
  # Docker
  yum -y install docker-io
  service docker start
  chkconfig docker on

  # Install MySQL
  yum -y install mysql

  # Install the JDK
  curl -LO 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie'
  rpm -i jdk-7u51-linux-x64.rpm
  /usr/sbin/alternatives --install /usr/bin/java java /usr/java/default/bin/java 200000
  rm jdk-7u51-linux-x64.rpm

  # Install scala
  rpm -ivh http://scala-lang.org/files/archive/scala-2.10.4.rpm
  
  # Install sbt
  su - vagrant -c "mkdir /home/vagrant/bin"
  curl -s https://raw.github.com/paulp/sbt-extras/master/sbt > /home/vagrant/bin/sbt && chmod 0755 /home/vagrant/bin/sbt 
  su - vagrant -c "/home/vagrant/bin/sbt -sbt-create"

  # Install Activator
  cd /opt
  sudo wget http://downloads.typesafe.com/typesafe-activator/1.1.1/typesafe-activator-1.1.1-minimal.zip
  sudo unzip typesafe-activator-1.1.1-minimal.zip 
  sudo chown vagrant:vagrant /opt/activator-1.1.1-minimal

  # tools etc
  yum -y install git wget zsh fakeroot dpkg
  su - vagrant -c "git config --global user.name "Giancarlo Inductivo""
  su - vagrant -c "git config --global user.email "gian@dynamicobjx.com""

  # Install Oh-My-Zsh
  su - vagrant -c "curl -L http://install.ohmyz.sh | sh"
  su - vagrant -c "chsh -s /bin/zsh"

  # Install giter8
  su - vagrant -c "curl https://raw.githubusercontent.com/n8han/conscript/master/setup.sh | sh"
  su - vagrant -c "cs n8han/giter8"

  # Local time
  mv /etc/localtime /etc/localtime.bak
  ln -s /usr/share/zoneinfo/Asia/Manila /etc/localtime

  touch /home/vagrant/.firstboot
fi

# Start MySQL
docker run -e MYSQL_PASS="Proverbs1423" -i -t -p 3306:3306 --name mysqld -d tutum/mysql

export JAVA_HOME=/usr/java/default/
export PATH=$PATH:$JAVA_HOME/bin:/home/vagrant/bin:/opt/activator-1.1.1-minimal


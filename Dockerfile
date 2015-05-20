# Base Image
FROM centos:7

# Maintainer/Author
MAINTAINER Luis Alberto Santana <jackboot7@gmail.com>

# Update package repository and install tools.
RUN yum -y update && yum clean all && yum -y install wget tar curl && yum clean all

# Install Java 7 from Oracle.
# Based on http://tecadmin.net/steps-to-install-java-on-centos-5-6-or-rhel-5-6/

# Download and decompress
RUN cd /opt && \
    curl -j -k -L -H "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz | tar xz
   
# Install Java with alternatives
RUN alternatives --install /usr/bin/java java /opt/jdk1.7.0_79/bin/java 2 && \ 
    alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_79/bin/javac 2 && \
    alternatives --install /usr/bin/jar jar /opt/jdk1.7.0_79/bin/jar 2

# Setup Java enviroment
ENV JAVA_HOME /opt/jdk1.7.0_79
ENV JRE_HOME=/opt/jdk1.7.0_79/jre
ENV PATH=$PATH:/opt/jdk1.7.0_79/bin:/opt/jdk1.7.0_79/jre/bin


# Install and configure JBoss AS7
#
# Set Jboss AS7 version
ENV AS7_VERSION 7.1.1.Final

# Create JBoss user
RUN groupadd -r jboss -g 433 && useradd -u 431 -r -g jboss -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss

# Download and decompress JBoss AS7
RUN cd /opt && \
    curl http://download.jboss.org/jbossas/7.1/jboss-as-$AS7_VERSION/jboss-as-$AS7_VERSION.tar.gz | tar xz  && \
    chown -R jboss:jboss /opt/jboss-as-$AS7_VERSION && \
    ln -s /opt/jboss-as-$AS7_VERSION /opt/jboss && chown -R jboss:jboss /opt/jboss

# Set the JBOSS_HOME env variable
ENV JBOSS_HOME /opt/jboss

# Expose the ports for JBoss AS7 and change the user
EXPOSE 8080 9990 
USER jboss

# Run JBoss AS7 on boot
CMD ["/opt/jboss/bin/standalone.sh", "-Djboss.bind.address=0.0.0.0", "-Djboss.bind.adress.management=0.0.0.0"]

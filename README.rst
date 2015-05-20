Centos 7 + Jboss AS7 Dockerfile
===============================

Based on the `centos/wildfly`_ Dockerfile, our project required to use Oracle's JVM (Java 1.7) and Jboss AS 7. You can create your image with the steps below or directly use the one that exists in the `Docker hub registry`_.

Usage
======

To boot in standalone mode

.. code::

    docker run -it jackboot7/jboss7

To boot in domain mode

.. code::

    docker run -it jackboot7/jboss7 /opt/jboss/bin/domain.sh -b 0.0.0.0 -Djboss. 0.0.0.0


Remember to bind your host ports to the ones in the container

.. code::
    
    EXPOSE <port> [<port>...]

From the docker documentation:

    The `EXPOSE` instructions informs Docker that the container will listen on the specified network ports at runtime. Docker uses this information to interconnect containers using links (see the Docker User Guide) and to determine which ports to expose to the host when using the -P flag. Note: EXPOSE doesn't define which ports can be exposed to the host or make ports accessible from the host by default. To expose ports to the host, at runtime, use the `-p` flag or the `-P` flag.

Application deployment
======================


1. Create Dockerfile with following content:

.. code::

    FROM jackboot7/jboss
    ADD your-app.war /opt/jboss/standalone/deployments/
    USER root
    RUN chown jboss:jboss /opt/jboss/standalone/deployments/your-app.war
    USER jboss

2. Place your `your-app.war` file in the same directory as your Dockerfile.
   
3. Run the build with docker build --tag=jboss-app .
   
4. Run the container with `docker run -it jboss-app`. Application will be deployed on the container boot.


.. _Docker hub registry: 
.. _centos/wildfly: https://github.com/CentOS/CentOS-Dockerfiles/blob/master/wildfly/centos7/Dockerfile

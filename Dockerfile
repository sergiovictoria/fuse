FROM jdk1.8.0_131 
MAINTAINER Sérgio da Victória <sergiodavictoria@hotmail.com>

USER root


ENV FUSE_VERSION 6.3.0.redhat-291
ENV FUSE_ARTIFACT_ID jboss-fuse-karaf
ENV FUSE_HOME "/home/jboss/app/jboss-fuse" 
ENV FUSE_DIR jboss-fuse

ENV FUSE_PUBLIC_OPENWIRE_PORT 61616
ENV FUSE_PUBLIC_MQTT_PORT 1883
ENV FUSE_PUBLIC_AMQP_PORT 5672
ENV FUSE_PUBLIC_STOMP_PORT 61613
ENV FUSE_PUBLIC_OPENWIRE_SSL_PORT 61617
ENV FUSE_PUBLIC_MQTT_SSL_PORT 8883
ENV FUSE_PUBLIC_AMQP_SSL_PORT 5671
ENV FUSE_PUBLIC_STOMP_SSL_PORT 61614


RUN groupadd -r jboss -g 433 && useradd -u 431 -r -g jboss -d /home/jboss -s /sbin/nologin -c "Jboss  Fuse Usuário" jboss

RUN wget http://origin-repository.jboss.org/nexus/content/groups/ea/org/jboss/fuse/${FUSE_ARTIFACT_ID}/${FUSE_VERSION}/${FUSE_ARTIFACT_ID}-${FUSE_VERSION}.zip
RUN jar -xvf ${FUSE_ARTIFACT_ID}-${FUSE_VERSION}.zip
RUN mkdir -p ${FUSE_HOME}
RUN mv ${FUSE_DIR}-${FUSE_VERSION}/* ${FUSE_HOME}
RUN rm -rf ${FUSE_DIR}-${FUSE_VERSION}
RUN rm -rf ${FUSE_ARTIFACT_ID}-${FUSE_VERSION}.zip 
RUN rm -rf ${FUSE_HOME}/extras
RUN rm -rf ${FUSE_HOME}/quickstarts
RUN chown jboss.jboss -R ${FUSE_HOME}
RUN chmod 755 -R ${FUSE_HOME}

RUN sed -i -e  's/#admin=/admin=/' ${FUSE_HOME}/etc/users.properties

EXPOSE 8181 8101 1099 44444 61616 1883 5672 61613 61617 8883 5671 61614

USER jboss

#
# The following directories can hold config/data, so lets suggest the user
# mount them as volumes.

VOLUME ${FUSE_HOME}/bin
VOLUME ${FUSE_HOME}/etc
VOLUME ${FUSE_HOME}/deploy
#VOLUME ${FUSE_HOME}/data
#VOLUME ${FUSE_HOME}/instances



# lets default to the jboss-fuse dir so folks can more easily navigate to around the server install
WORKDIR ${FUSE_HOME}
CMD ${FUSE_HOME}"/bin/fuse" "server" 

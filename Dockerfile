FROM showtimeanalytics/java-jre:8u51
MAINTAINER Alberto Gregoris <alberto@showtimeanalytics.com>

ENV SERVICE_NAME=nexus \
    SERVICE_BASE=/opt/sonatype \
    SERVICE_HOME=/opt/sonatype/nexus \
    SERVICE_WORK=/opt/sonatype-work/nexus \
    SERVICE_USER=nexus \
    SERVICE_UID=10000 \
    SERVICE_GROUP=nexus \
    SERVICE_GID=10000 \
    SERVICE_CONF=0 \
    SERVICE_VERSION=2.12.1-01 \
    SERVICE_URL=https://download.sonatype.com/nexus/oss

# Install service software
RUN SERVICE_RELEASE=nexus-${SERVICE_VERSION} \
  && mkdir -p ${SERVICE_WORK} ${SERVICE_BASE} \
  && curl -jksSL ${SERVICE_URL}/${SERVICE_RELEASE}-bundle.tar.gz | gunzip -c - | tar -xf - -C /tmp \
  && mv /tmp/${SERVICE_RELEASE} ${SERVICE_HOME} \
  && addgroup -g ${SERVICE_GID} ${SERVICE_GROUP} \
  && adduser -g "${SERVICE_NAME} user" -D -h ${SERVICE_WORK} -G ${SERVICE_GROUP} -s /sbin/nologin -u ${SERVICE_UID} ${SERVICE_USER}

ADD root /
RUN chmod +x ${SERVICE_HOME}/bin/*.sh ${SERVICE_HOME}/bin/nexus \
  && chown -R ${SERVICE_USER}:${SERVICE_GROUP} ${SERVICE_HOME} ${SERVICE_WORK}

USER $SERVICE_USER
WORKDIR $SERVICE_HOME

EXPOSE 8081
# Ready to use as a service including files from "root" to "/" and using a monitoring process like monit
#CMD ["/opt/sonatype/nexus/bin/nexus-service.sh", "start"]


ENV CONTEXT_PATH /
ENV MAX_HEAP 768m
ENV MIN_HEAP 256m
ENV JAVA_OPTS -server -Djava.net.preferIPv4Stack=true
ENV LAUNCHER_CONF ./conf/jetty.xml ./conf/jetty-requestlog.xml
CMD ${JAVA_HOME}/bin/java \
  -Dnexus-work=${SERVICE_WORK} -Dnexus-webapp-context-path=${CONTEXT_PATH} \
  -Xms${MIN_HEAP} -Xmx${MAX_HEAP} \
  -cp 'conf/:lib/*' \
  ${JAVA_OPTS} \
  org.sonatype.nexus.bootstrap.Launcher ${LAUNCHER_CONF}

FROM adoptopenjdk:8-jdk-hotspot

LABEL maintainer "CodeLibs, Inc."

ENV H2O_HOME /opt/h2o
COPY start-h2o-docker.sh /opt/h2o/bin/start-h2o-docker.sh
RUN curl http://h2o-release.s3.amazonaws.com/h2o/rel-yule/2/h2o-3.28.1.2.zip \
    -o /opt/h2o.zip && \
    cd /opt && \
    jar xvf /opt/h2o.zip && \
    cd `find . -name 'h2o.jar' | sed 's/.\///;s/\/h2o.jar//g'` && \ 
    cp h2o.jar $H2O_HOME && \
    mkdir $H2O_HOME/logs && \
    chmod +x /opt/h2o/bin/start-h2o-docker.sh && \
    rm -rf /opt/h2o-* /opt/h2o.zip

# Define the working directory
WORKDIR /data

EXPOSE 54321
EXPOSE 54322

CMD ["/bin/bash", "/opt/h2o/bin/start-h2o-docker.sh"]

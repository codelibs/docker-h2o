FROM eclipse-temurin:11-focal

LABEL maintainer "CodeLibs, Inc."

ENV H2O_HOME /opt/h2o
COPY start-h2o-docker.sh ${H2O_HOME}/bin/start-h2o-docker.sh
COPY dist/h2o.jar $H2O_HOME

# Define the working directory
WORKDIR /data

EXPOSE 54321
EXPOSE 54322

CMD ["/bin/bash", "/opt/h2o/bin/start-h2o-docker.sh"]


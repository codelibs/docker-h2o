FROM adoptopenjdk:11-jdk-hotspot-bionic as builder

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /build

RUN apt update && \
    apt install -y wget curl s3cmd libffi-dev libxml2-dev libssl-dev \
    libcurl4-openssl-dev libfreetype6 libfreetype6-dev libfontconfig1 \
    libfontconfig1-dev build-essential chrpath libxft-dev \
    git unzip python-pip python-dev python-virtualenv libmysqlclient-dev \
    texlive texlive-fonts-extra texlive-htmlxml python3 python3-dev \
    python3-pip python3-virtualenv software-properties-common \
    software-properties-common texinfo texlive-bibtex-extra \
    texlive-formats-extra texlive-generic-extra r-base r-base-dev \
    python-gssapi libkrb5-dev libmysqlclient-dev && \
    R -e 'chooseCRANmirror(graphics=FALSE, ind=54);install.packages(c("R.utils", "AUC", "mlbench", "flexclust", "randomForest", "bit64", "HDtweedie", "RCurl", "jsonlite", "statmod", "devtools", "roxygen2", "testthat", "Rcpp", "fpc", "RUnit", "ade4", "glmnet", "gbm", "ROCR", "e1071", "ggplot2", "LiblineaR", "survival"))' && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update -q -y && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/cache/apt/*

ARG GIT_BRANCH=master
ARG BUILD_NUMBER=0

RUN git clone https://github.com/h2oai/h2o-3.git -b $GIT_BRANCH && \
    rm /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python && \
    pip3 install --upgrade pip && \
    pip3 install -r h2o-3/h2o-py/test-requirements.txt && \
    useradd -m -u 1000 docker && chown -R docker /build

USER docker

ADD h2o.patch .
RUN cd h2o-3 && \
    git apply ../h2o.patch && \
    echo "BUILD_NUMBER=$BUILD_NUMBER" > gradle/buildnumber.properties && \
    ./gradlew build -x test

FROM adoptopenjdk:11-jdk-hotspot-bionic

LABEL maintainer "CodeLibs, Inc."

ENV H2O_HOME /opt/h2o
COPY start-h2o-docker.sh /opt/h2o/bin/start-h2o-docker.sh
COPY --from=builder /build/h2o-3/build/h2o.jar $H2O_HOME

# Define the working directory
WORKDIR /data

EXPOSE 54321
EXPOSE 54322

CMD ["/bin/bash", "/opt/h2o/bin/start-h2o-docker.sh"]

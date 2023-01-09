FROM eclipse-temurin:11-jdk-focal as builder

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /build

RUN apt update && \
    apt install -y wget curl s3cmd libffi-dev libxml2-dev libssl-dev \
    libcurl4-gnutls-dev libfreetype6 libfreetype6-dev libfontconfig1 \
    libfontconfig1-dev build-essential chrpath libxft-dev python3-pandas \
    git unzip libmysqlclient-dev texlive-full python3 python3-dev \
    python3-pip python3-virtualenv software-properties-common \
    software-properties-common texinfo libgit2-dev r-base r-base-dev \
    python3-virtualenv python3-gssapi libkrb5-dev libmysqlclient-dev && \
    R -e 'chooseCRANmirror(graphics=FALSE, ind=54);install.packages(c("R.utils", "AUC", "mlbench", "flexclust", "randomForest", "bit64", "HDtweedie", "RCurl", "jsonlite", "statmod", "devtools", "roxygen2", "testthat", "Rcpp", "fpc", "RUnit", "ade4", "glmnet", "gbm", "ROCR", "e1071", "ggplot2", "LiblineaR", "survival"))' && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get update -q -y && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/cache/apt/*

ARG GIT_BRANCH=master
ARG BUILD_NUMBER=0

RUN git clone https://github.com/h2oai/h2o-3.git -b $GIT_BRANCH && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    pip3 install --upgrade pip
ADD test-requirements.txt h2o-3/h2o-py/test-requirements.txt
RUN pip3 install -r h2o-3/h2o-py/test-requirements.txt && \
    useradd -m -u 1000 docker && chown -R docker /build

USER docker

ENV R_LIBS_USER=/build/h2o-3/Rlibrary

ADD h2o.patch .
WORKDIR /build/h2o-3
RUN git apply ../h2o.patch && \
    echo "BUILD_NUMBER=$BUILD_NUMBER" > gradle/buildnumber.properties && \
    mkdir -p ${R_LIBS_USER} && \
    ./gradlew clean
RUN ./gradlew --parallel build \
      -x test -x :h2o-r:buildPackageDocumentation \
      --info --stacktrace


FROM eclipse-temurin:11-focal

LABEL maintainer "CodeLibs, Inc."

ENV H2O_HOME /opt/h2o
COPY start-h2o-docker.sh /opt/h2o/bin/start-h2o-docker.sh
COPY --from=builder /build/h2o-3/build/h2o.jar $H2O_HOME

# Define the working directory
WORKDIR /data

EXPOSE 54321
EXPOSE 54322

CMD ["/bin/bash", "/opt/h2o/bin/start-h2o-docker.sh"]


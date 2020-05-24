Docker for H2O
=====

See [https://hub.docker.com/r/codelibs/h2o/](https://hub.docker.com/r/codelibs/h2o/).

## Docker Images

-   [`3.30.0.3`](https://github.com/codelibs/docker-h2o/blob/master/Dockerfile)

## Getting Started

You can access http://localhost:54321 from the host OS with:

```console
$ docker run -it -p 54321:54321 codelibs/h2o:snapshot
```

## Build

To build docker images, run as below:

```console
$ docker build --rm -t codelibs/h2o:snapshot .
```

To build it on release tag,

```console
$ docker build --rm -t codelibs/h2o:3.30.0.3 --build-arg GIT_BRANCH=jenkins-3.30.0.3 --build-arg BUILD_NUMBER=3 .
```


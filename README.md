Docker for H2O
=====

See [Packages](https://github.com/orgs/codelibs/packages/container/package/h2o).

## Docker Images

-   [`3.36.1.1`](https://github.com/codelibs/docker-h2o/blob/master/Dockerfile)

## Getting Started

You can access http://localhost:54321 from the host OS with:

```console
$ docker run -it -p 54321:54321 ghcr.io/codelibs/h2o:3.36.1.1
```

## Build

To build docker images, run as below:

```console
$ docker build --rm -t ghcr.io/codelibs/h2o:snapshot .
```

To build it on release tag,

```console
$ docker build --rm -t ghcr.io/codelibs/h2o:3.36.1.1 --build-arg GIT_BRANCH=jenkins-3.36.1.1 --build-arg BUILD_NUMBER=1 .
```


Docker for H2O
==============

See [Packages](https://github.com/orgs/codelibs/packages/container/package/h2o).

## Docker Images

-   [`3.40.0.4`](https://github.com/codelibs/docker-h2o/blob/master/Dockerfile)

## Getting Started

You can access http://localhost:54321 from the host OS with:

```console
$ docker run -it -p 54321:54321 ghcr.io/codelibs/h2o:3.40.0.4
```

## Build

To build docker images, run as below:

```console
$ bash ./build.sh build 3.40.0 4
```


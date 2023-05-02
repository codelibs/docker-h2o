#!/bin/bash

base_dir=$(cd $(dirname $0);pwd)

sub_command=$1
base_version=$2
build_number=$3

if [ "${sub_command}" != "push" ] && [ "${sub_command}" != "build" ] ; then
  echo "Sub command is push or build."
  exit 1
fi

if [ "${base_version}" = "" ] || [ "${build_number}" = "" ] ; then
  echo "Command arguments are x.x.x x"
  exit 1
fi

h2o_version=${base_version}.${build_number}

build_image_tag=ghcr.io/codelibs/h2o-build:${h2o_version}
image_tag=ghcr.io/codelibs/h2o:${h2o_version}
dist_dir=${base_dir}/dist
src_path=/build/h2o-3/build/h2o.jar
dist_path=${dist_dir}/h2o.jar

rm -rf ${dist_dir}

echo "Building ${build_image_tag}"
docker build --rm -t ${build_image_tag} --build-arg GIT_BRANCH=jenkins-${h2o_version} --build-arg BUILD_NUMBER=${build_number} -f Dockerfile.build .

mkdir -p ${dist_dir}
container_id=$(docker create "$build_image_tag")
docker cp "$container_id:$src_path" "$dist_path"
docker rm "$container_id"

if [[ ! -f ${dist_path} ]] ; then
  echo "${dist_path} does not exist."
  exit 1
fi

if [ "${sub_command}" = "build" ] ; then
  echo "Building ${image_tag}"
  docker build --rm -t ${image_tag} .
else
  echo "Pushing ${image_tag}"
  docker buildx build --rm --platform linux/amd64,linux/arm64 -t ${image_tag} --push .
fi


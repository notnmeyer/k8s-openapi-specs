#!/usr/bin/env bash
set -eu

# stop any background processes left behind if the script crashes or is interrupted
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM

# delete any clusters left behind 
trap clean SIGINT SIGTERM

function clean {
  kind delete clusters "${k8s_versionss}"
}

# https://hub.docker.com/r/kindest/node/tags
image="kindest/node"
k8s_versions="1.24.7 1.25.3 1.26.2"

# get the v2 specs
for version in ${k8s_versions}
do
  kind create cluster --name="$version" --image="${image}:v${version}"

  kubectl proxy --port=8080 --context=kind-${version} &
  proxy_pid=$! # we need to kill this later

  sleep 1
  curl -s localhost:8080/openapi/v2 > "output/k8s-${version}.json"

  kill "$proxy_pid"
  kind delete clusters "$version" 
done

for version in ${k8s_versions}
do
  # convert v2 to v3
  ./convert-swagger-v2-to-openapi-v3.sh "output/k8s-${version}.json"

  # upload
  ./push-to-optic.sh "output/v3__k8s-${version}.json" "v${version}"
done
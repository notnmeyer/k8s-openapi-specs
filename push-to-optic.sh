#!/usr/bin/env bash

# this assumes you've already run `optic spec add` once to get your x-optic-url
# e.g., `optic api add ./v3__k8s-1.24.7.json  --all`

file="$1"
tag="$2"

optic spec push "$file" --tag "$tag"
# k8s-openapi-specs

A simple tool for grabbing the OpenAPI specs from a reference Kubernetes cluster. Uses
[Kind](https://kind.sigs.k8s.io) to create temporary clusters and writes the cluster's
OpenAPI spec to the `output` directory.
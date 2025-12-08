# Kong EE on Kubernetes

This sample shows how to deploy a minimal installation of Kong EE on Kubernetes with Helm, Postgres with the CloudNative PG Operator, and uses PKI certs for cluster mTLS.

### Prerequisites
* A Kubernetes installation. I have tested this with [minikube](https://minikube.sigs.k8s.io/docs/).
* This script uses [Taskfile](https://taskfile.dev/), a `make` alternative for modern automation.

### Get started
1. Run `./gen-certs.sh` to generate the PKI certs for mTLS (CA, control plane, data plane)
2. Run `task install`

This will install Kong 3.12. To use another image, set `KONG_TAG`: `export KONG_TAG=3.13` before running starting the installation.
# Kong EE on Kubernetes

This sample shows how to deploy a minimal installation of Kong EE on Kubernetes with Helm, Postgres with the CloudNative PG Operator, and uses PKI certs for cluster mTLS.

### Prerequisites
* A Kubernetes installation. I have tested this with [minikube](https://minikube.sigs.k8s.io/docs/).
* This script uses [Taskfile](https://taskfile.dev/), a `make` alternative for modern automation.
* The [decK tool](https://developer.konghq.com/deck/) must be installed.

### Get started
1. Run `./gen-certs.sh` to generate the PKI certs for mTLS (CA, control plane, data plane)
2. Run `task install`
3. Port forward Kong admin API, manager, proxy, and status:
```
kubectl port-forward service/kong-cp-kong-admin 8001:8001 -n kong
kubectl port-forward service/kong-cp-kong-manager 8002:8002 -n kong
kubectl port-forward service/kong-dp-kong-proxy 8000:80 -n kong
kubectl port-forward service/kong-dp-status 8100:8100 -n kong
```
4. Sync the Kong configuration with `deck gateway sync -f kong/kong.yaml`

This will install Kong 3.12. To use another image, set `KONG_TAG`: `export KONG_TAG=3.13` before running starting the installation.

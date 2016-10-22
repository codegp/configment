configuration and deployment

## Local cluster setup
##### Prerequisites
Install [minikube](https://github.com/kubernetes/minikube), [ktmpl](https://github.com/InQuicker/ktmpl), and [dvm](https://github.com/getcarina/dvm)

##### Starting the local cluster
```
source ./setup_minikube.sh
```

To wipe all deployments and services to start fresh run
```
source ./setup_minikube.sh -w
```

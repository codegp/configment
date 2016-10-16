configuration and deployment

## Local cluster setup
##### Prerequisites
Install [minikube](https://github.com/kubernetes/minikube) and [dvm](https://github.com/getcarina/dvm)

##### Starting the local cluster
```
source setup_minikube.sh
```

### gcds.yaml
Service and pod configuration for datastore emulator (For local use only)
```
kubectl [create | replace] -f gcds.yaml
```

### localfs.yaml
Service and pod configuration for the local file system used to emulate cloud storage (For local use only). The docker file in the localfs directory must be built prior to deploying this pod.
```
kubectl [create | replace] -f localfs.yaml
```

### minikubeconf.yaml
ConfigMap for the local codegp environment (For local use only)
```
kubectl [create | replace] -f minikubeconf.yaml
```

### gkeconf.yaml
ConfigMap for the prod codegp environment
```
kubectl [create | replace] -f gkeconf.yaml
```

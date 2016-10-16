configuration and deployment

### gcds.yaml
Service and pod configuration for datastore emulator (For local use only)
```
kubectl create -f gcds.yaml
```

### localfs.yaml
Service and pod configuration for the local file system used to emulate cloud storage (For local use only). The docker file in the localfs directory must be built prior to deploying this pod.
```
kubectl create -f localfs.yaml
```

### minikubeconf.yaml
ConfigMap for the local codegp environment (For local use only)
```
kubectl create -f minikubeconf.yaml
```

### gkeconf.yaml
ConfigMap for the prod codegp environment
```
kubectl create -f gkeconf.yaml
```

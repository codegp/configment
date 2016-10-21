#!/bin/bash

REPO_ROOT=$GOPATH/src/github.com/codegp/configment
PROJECT_ID=$(gcloud config list project --format "value(core.project)" 2> /dev/null)
SERVER_TAG="latest"
CLIENT_TAG="latest"
WIPE=false

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -c |--client-tag)
            CLIENT_TAG=$VALUE
            ;;
        -s | --server-tag)
            SERVER_TAG=$VALUE
            ;;
        -w | --wipe)
            WIPE=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            exit 1
            ;;
    esac
    shift
done

waitFor0Exit () {
  echo "wait $1"
  until eval "$1";  do
    sleep 0.5
  done
}

if minikube status | grep -q 'Stopped'; then
  minikube start
fi

eval $(minikube docker-env)

if dvm current | grep -q '1.11.1'; then
  dvm use 1.11.1
fi

if $WIPE; then
  echo "Wiping"
  kubectl delete deployments --all
  kubectl delete services --all
  kubectl delete configMap codegp-config
fi

if ! docker images | grep -q localfs; then
  echo "Building localfs container..."
  cd $REPO_ROOT/localfs
  CGO_ENABLED=0 go build
  docker build -t gcr.io/local/localfs .
  echo "Done building localfs container"
fi

cd $REPO_ROOT
if ! kubectl get deployments | grep -q dsemulator; then
  echo "Starting datastore emulator"
  kubectl create -f gcds.yaml
  waitFor0Exit 'kubectl get pods | grep dsemulator | grep -q Running'
fi

if ! kubectl get deployments | grep -q localfs; then
  echo "Starting localfs"
  kubectl create -f localfs.yaml
fi

DATASTORE_EMULATOR_HOST=$(kubectl get -o json service dsemulator-service  | jq -r '.spec.clusterIP')
if ! kubectl get configmaps | grep -q codegp-config; then
  echo "Setting minikube configuration with ds ip of $DATASTORE_EMULATOR_HOST:80"
  ktmpl configmap.yaml -p DATASTORE_EMULATOR_HOST $DATASTORE_EMULATOR_HOST:80 | kubectl create -f -
fi

if ! kubectl get services | grep -q app-server; then
  echo "Setting up app-server service"
  kubectl create -f app-server-service.yaml
fi

if ! kubectl get pods | grep -q app-server; then
  echo "starting app-server container"
  ktmpl app-server.yaml \
    -p TAG $SERVER_TAG \
    -p GCLOUD_PROJECT_ID $PROJECT_ID | kubectl create -f -
fi

if ! kubectl get services | grep -q app-client; then
  echo "Setting up app-client service"
  kubectl create -f app-client-service.yaml
fi

if ! kubectl get pods | grep -q app-client; then
  echo "starting app-client container"
  ktmpl app-client.yaml \
    -p TAG $CLIENT_TAG \
    -p GCLOUD_PROJECT_ID $PROJECT_ID | kubectl create -f -
fi

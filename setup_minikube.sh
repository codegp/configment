#!/bin/bash

REPO_ROOT=$GOPATH/src/github.com/codegp/configment

if [ $(minikube status) == "Stopped" ]
then
  minikube start
fi

eval $(minikube docker-env)

if [ $(dvm current) == "1.11.1"]
then
  dvm use 1.11.1
fi


if ! docker images | grep -q localfs; then
  echo "Building localfs container..."
  cd $REPO_ROOT/localfs
  CGO_ENABLED=0 go build
  docker build -t local/codegp/localfs .
  echo "Done building localfs container"
fi

cd $REPO_ROOT
if ! kubectl get configmaps | grep -q codegp-config; then
  echo "Setting minikube configuration"
  kubectl create -f minikubeconf.yaml
fi

if ! kubectl get pods | grep -q dsemulator; then
  echo "Starting datastore emulator"
  kubectl create -f gcds.yaml
fi

if ! kubectl get pods | grep -q localfs; then
  echo "Starting localfs"
  kubectl create -f localfs.yaml
fi

if ! kubectl get services | grep -q gameconsole; then
  echo "Setting up gameconsole service"
  kubectl create -f gameconsole-service-local.yaml
fi

if ! kubectl get pods | grep -q gameconsole; then
  echo "starting gameconsole container"
  kubectl create -f gameconsole-local.yaml
fi

#!/bin/bash

set -e

REPO_ROOT=$GOPATH/src/github.com/codegp/configment

if [$(minikube status) -eq "Stopped"]
then
  minikube start
fi

dvm use 1.11.1
eval $(minikube docker-env)

if [ ! -z $(docker images | grep localfs) ]
then
  cd $REPO_ROOT/localfs
  CGO_ENABLED=0 go build
  docker build -t local/codegp/localfs .
fi

cd $REPO_ROOT
if [ ! -z $(kubectl get configmaps | grep codegp-config) ]
then
  kubectl create -f minikubeconf.yaml
fi

if [ ! -z $(kubectl get pods | grep dsemulator) ]
then
  kubectl create -f gcds.yaml
fi

if [ ! -z $(kubectl get pods | grep localfs) ]
then
  kubectl create -f localfs.yaml
fi

if [ ! -z $(kubectl get services | grep gameconsole) ]
then
  kubectl create -f gameconsole-service-local.yaml
fi

if [ ! -z $(kubectl get pods | grep gameconsole) ]
then
  kubectl create -f gameconsole-local.yaml
fi

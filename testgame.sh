#!/bin/bash

PROJECT_ID=$(gcloud config list project --format "value(core.project)" 2> /dev/null)
ktmpl setuprunner.yaml -p GCLOUD_PROJECT_ID $PROJECT_ID -p RUN_GAME true | kubectl create -f -


for each in $(kubectl get pods -a | grep -v Running | grep -v STATUS | cut -f1 -d" ");
do
  kubectl delete pod $each
done
docker rm -v $(docker ps -a -q -f status=exited)

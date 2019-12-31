# K8S

[Overview of kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)

## Help

```bash
kubectl --help
kubectl get nodes --help
```

## Top `kubectl` commands

* use on node, pods, deployments

```bash
kubectl get
kubectl get -o wide
kubectl describe
kubectl logs
kubectl exec
kubectl exec -ti
```

## Start with Minikube

```bash
minikube version
minikube start
minikube ip

kubectl version
kubectl cluster-info

kubectl get nodes
```

start minikube

```bash
# from start.sh for https://kubernetes.io/docs/tutorials/hello-minikube/
minikube version
minikube start --wait=false
minikube addons enable dashboard
kubectl apply -f /opt/kubernetes-dashboard.yaml
minikube status
```

## Deployment

```bash
# view config
kubectl config view

# open dashboard
minikube dashboard

## create a deployment
# add `--expose` to create a service at the same time
kubectl create deployment <some-name> --image=<some-image>

# view deployments
kubectl get deployments
# view pods
kubectl get pods
# view events
kubectl get events
# view services
kubectl get services

# view pod and services
kubectl get pod,svc -n kube-system
# view with template
kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'
```

## Service

Service Types (in ServiceSpec)

* ClusterIP (default)
* NodePort
* LoadBalancer
* ExternalName (1.7 or higher of `kube-dns`)

```bash
# expose (create) Service outside of the cluster
kubectl expose deployment hello-node --type=LoadBalancer --port=8080
kubectl expose deployment/hello --type="NodePort" --port=8080

## LoadBalancer type makes Services in minikube accessible via:
## minikube service <some-service>

# get NodePort (output has no newline)
kubectl get services/<some-service> -o go-template='{{(index .spec.ports 0).nodePort}}'
kubectl get svc <some-service> -o go-template='{{(index .spec.ports 0).nodePort}}'
```

## Proxy

```bash
# forward communication to in-cluster private network
# ctrl-C to stop
kubectl proxy

# get proxy node name via:
kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'
# node will be accessible via route:
http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/proxy/
```

## Addons

```bash
# currently supported addons
minikube addons list
minikube addons enable <some-addon>
minikube addons disable <some-addon>
```

## Delete

```bash
kubectl delete service <some-service>
kubectl delete service -l <some-service-label>
kubectl delete deployment <some-deployment>

# stop minikube VM
minikube stop

# delete minikube VM
minikube delete
```

## Exec

```bash
kubectl exec <some-pod-name> env
kubectl exec -ti <some-pod-name> bash
```

## Labels

[Labels and Selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)

Query

```bash
# example way to get labels of deployments
kubectl describe deployment
# query list of Pods
kubectl get pods -l <some-label>
```

Change

```bash
kubectl label pod <some-pod-name> app=v0
```

## Scale

[Horizontal Pod Autoscale](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)

```bash
# set 0 to remove all replicas
kubectl scale deployment <some-deployment> --replicas=4
```

## Update

```bash
kubectl set image --help
kubectl set image deployments <some-resource> <some-container>=<some-target-container-image>:v2

# check rollout status
kubectl rollout status <some-resource>

# rollback
kubectl rollout undo <some-resource>
```

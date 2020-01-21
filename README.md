# kubectl
A container includes command kubectl and auto setup kube_config by POD's RBAC

Download image from docker hub

```
docker pull abola/kubectl:1.2
```

Or build image from localy

```
git clone https://github.com/abola/kubectl.git
sudo docker build -t kubectl kubectl/docker/
```


### Deploy simple demo script

```shell
# Creating a namespace demo
kubectl create ns demo


# Set a service account and binding a pod reader role 
kubectl create serviceaccount jojo -n=demo
kubectl create role pod-reader --verb=get --verb=list --verb=watch --resource=pods -n=demo
kubectl create rolebinding pod-readers --role=pod-reader --serviceaccount=demo:jojo --namespace=demo


# Running a demo pod with serviceaccount: jojo
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: demo-pod
  namespace: demo
spec:
  containers:
  - name: kubectl
    image: abola/kubectl:1.2
    args:
    - sleep
    - "100000"
  serviceAccount: jojo
EOF

```

### Running kubectl command in the pod, permission same as serviceaccount:jojo 

```
# jojo can `list` pods in the "demo" namespace
kubectl exec demo-pod -n=demo -- kubectl get po

# jojo can `get` pods in the "demo" namespace
kubectl exec demo-pod -n=demo -- kubectl describe po demo-pod

# jojo "can not" `edit` pods 
kubectl exec demo-pod -n=demo -- kubectl edit po demo-pod

# jojo "can not" `list` namespace
kubectl exec demo-pod -n=demo -- kubectl get ns
```

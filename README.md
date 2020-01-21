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
cat<<EOF | kubectl apply -f -
# Creating a new service account jojo in the "demo" namespace 
apiVersion: v1
kind: ServiceAccount
metadata:
  name: jojo
  namespace: demo
---
# Pod reader role
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: demo
  name: pod-reader
rules:
- apiGroups: [""] 
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
---
# Allows user jojo to read pods in the "demo" namespace.
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-readers
  namespace: demo
subjects:
- kind: ServiceAccount
  name: jojo
  namespace: demo
roleRef:
  kind: Role 
  name: pod-reader 
  apiGroup: rbac.authorization.k8s.io
EOF

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

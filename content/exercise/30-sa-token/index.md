+++
categories = []
date = "2020-02-20"
description = ""
slug = ""
tags = []
title = "Disable service account token auto-provisioning"
draft = false
toc = true
weight = 30
+++

<!-- TODO: Tune RBAC as a separate item? (see 40-rbac) -->

### Introduction
In this exercise, we cover:

 - How service account identities are given to pods
 - What access they have
 - How you can remove them if you don't need them

### How to use it yourself
Disable the `automountServiceAccountToken` field in the [`PodSpec`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.15/#podspec-v1-core)
and in the service account itself.
Note how these interact: TODO

### Setup
In this example, we'll just directly use a shell inside the app.
We'll start with a default configuration and see what we can do.

We'll also deploy an example where a service account has more
access than required--say, it was intended to be used in one app
and is not needed in another.

### "Attack"
Download kubectl for easy probing.
(Your pod is writable, so this is easy--thanks!)
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x kubectl
```
<!-- TODO: Switch to base image with curl built in, for convenience.  -->
Perform queries to find out what we're authorized to do:
```
./kubectl auth can-i --list
```
Note what's mounted:
```
ls /var/run/secrets/kubernetes.io/serviceaccount/
```
To make this a bit more interesting, grant some privileges within the same namespace (which is relatively common):
```
kubectl apply -f rbac.yaml
```
Do some of those things.
```
# ./kubectl get po --all-namespaces
Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:sa:default" cannot list resource "pods" in API group "" at the cluster scope
# ./kubectl get po -n sa
NAME                    READY   STATUS    RESTARTS   AGE
shell-5485958cc-2hvj8   1/1     Running   0          117s
```

### Countermeasure
First, grant a smaller role to the service account.
Then, disable token automount in the pod.

```
# kubectl delete -f rbac.yaml
role.rbac.authorization.k8s.io "edit" deleted
rolebinding.rbac.authorization.k8s.io "manage-namespace" deleted
# kubectl apply -f rbac-streamlined.yaml
```

(This lets us see how to improve when API access is required,
and when it's not.)

### Attack effects after patching
We can't do anything in the Kubernetes API anymore.
We don't even have any secrets mounted:
```
ls /var/run/
```
(No `/secrets` subdirectory.)
You can't find out what you're allowed to do, either:
```
./kubectl auth can-i --list
```

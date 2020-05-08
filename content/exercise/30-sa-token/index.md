+++
categories = []
date = "2020-02-22"
description = ""
slug = ""
tags = []
title = "Tune Kubernetes RBAC and account provisioning"
draft = false
toc = true
weight = 30
+++

### Introduction
In this exercise, we cover:

 - How service account identities are given to pods
 - What access they have
 - How you can remove them if you don't need them

### Setup
In this example, we'll just directly use a shell inside the app.
We'll start with a default configuration and see what we can do.

We'll also deploy an example where a service account has more
access than required--say, it was intended to be used in one app
and is not needed in another.

Let's get deployed:
```
kubectl apply -f https://securek8s.dev/sa/base.yaml -f https://securek8s.dev/sa/rbac.yaml
```

Find a pod:
```
kubectl get po -n sa
```

Then exec inside:
```
kubectl exec -it -n sa $(kubectl get po -n sa --output=jsonpath='{.items[0].metadata.name}') bash
```

### "Attack"
Download kubectl for easy probing.
(Your pod is writable, so this is easy--thanks!)

First install `curl`:
```
apt-get update
apt-get install -y curl
```

Then add `kubectl`:
```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x kubectl
```

Note what's mounted:
```
ls /var/run/secrets/kubernetes.io/serviceaccount/
```

Perform queries to find out what we're authorized to do:
```
./kubectl auth can-i --list
```

😱 Those stars at the top mean that we can do anything!

```
Resources                  Non-Resource URLs   Resource Names   Verbs
*.*                        []                  []               [*]
```

This is super dangerous! As Ian Coldwater tweeted:

{{< tweet 1225949531512197126 >}}

Let's do some of the stuff we're allowed to. The first may fail depending on the cluster setup. But others won't.
```
# ./kubectl get po --all-namespaces
Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:sa:default" cannot list resource "pods" in API group "" at the cluster scope
# ./kubectl get po -n sa
NAME                    READY   STATUS    RESTARTS   AGE
shell-5485958cc-2hvj8   1/1     Running   0          117s
# ./kubectl run --rm -it --image ubuntu -- bash
```

Hit `Ctrl-D` twice—once to get our of the Ubuntu container, then to get out of the first one we entered.

### Countermeasure
We'll:
 - grant a smaller role to the service account, and
 - disable token automount in the pod.

```
kubectl auth reconcile -f https://securek8s.dev/sa/rbac-streamlined.yaml
kubectl apply -f https://securek8s.dev/sa/no-sa-mount.yaml
```

Find a pod:
```
kubectl get po -n sa
```

Then exec inside:
```
kubectl exec -it -n sa $(kubectl get po -n sa --output=jsonpath='{.items[0].metadata.name}') bash
```

### Attack effects after patching
We can't do anything in the Kubernetes API anymore.
We don't even have any secrets mounted:
```
ls /var/run/
```
(No `/secrets` subdirectory.)

You can't find out what you're allowed to do, either:
```
apt-get update
apt-get install -y curl
```

```
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x kubectl
./kubectl auth can-i --list
```

Hit `Ctrl-D` to exit the pod.

### How to use it yourself
Disable the `automountServiceAccountToken` field in the [`PodSpec`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.15/#podspec-v1-core).

You can also disable it in the service account spec.

These can interact confusingly; check [the docs](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#use-the-default-service-account-to-access-the-api-server).

### Next up
We'll cover how namespaces can help you implement security "speed bumps" in the next exercise:

[**Use separate namespaces**](../50-ns)

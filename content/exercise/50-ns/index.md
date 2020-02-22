+++
categories = []
date = "2020-02-22"
description = ""
slug = ""
tags = []
title = "Use separate namespaces"
draft = false
toc = true
weight = 50
+++

### Introduction
In this exercise, we cover:

 - What namespaces are
 - How various types of Kubernetes objects treat namespace boundaries

### Setup
In this example, we'll use shells inside of apps to see
how they can talk to one another.
We'll also intentionally make some mistakes and see if
Kubernetes tells us we did something wrong.

Let's start with everything in the default namespace:

```
kubectl apply -f https://securek8s.dev/namespaces/default.yaml
```

### "Attack"
Contact other services in the same namespace, and accidentally mount a secret.
The secret is mounted into both deployments in the default namespace, even though `bad-server` "shouldn't" have it.

Let's try to reach out from `bad-server` to `server`.

Find a pod:
```
kubectl get pod
```

Exec into it:
```
kubectl exec -it <pod> bash
```

Then install `curl` and note that we can reach the other service:
```
apt-get update && apt-get install -y curl
curl http://server
```

We also have our unexpected secret, which has proxy credentials... something like `bad-server` doesn't seem like it should have those...

```
cat /my-config/config.yaml
```

### Countermeasure
Move deployments into separate namespaces.

```
kubectl delete -f https://securek8s.dev/namespaces/default.yaml
```

Try to create a split-up version (with a mistake!):

```
kubectl apply -f https://securek8s.dev/namespaces/split.yaml
```

This will fail to launch the `bad-server` pod because we're accidentally mounting a secret, and now it's over a namespace boundary.
The pod itself will fail to create, so you'll only see an error if you check the pods:

```
kubectl get pod -n bad
kubectl describe pod -n bad
```

So let's deploy a fixed version:

```
kubectl apply -f https://securek8s.dev/namespaces/split-no-mount.yaml
```

Now the pod will deploy:

```
kubectl get pod -n bad
```

### Attack effects after patching
Let's exec in:
```
kubectl exec -it -n bad <pod> bash
```

And then let's repeat our attempt to contact the good server:
```
apt-get update && apt-get install -y curl
curl http://server.good
```

Note, we've had to give a name that includes the other service's namespace, now that we are in another namespace.
It won't work! Good.

Just to be sure we didn't break _everything_, let's check we can talk to our own bad-server:

```
curl http://bad-server
```

### How to use it yourself
`kubectl create ns <your-namespace>` (or use a YAML, as shown in the example).

Then include `namespace: <your-namespace>` in the `meta` for your object.

After that, use the `-n` argument in commands, for example:
`kubectl get all -n <your-namespace>`.

### Next up
We'll cover the use of non-root user identities in the next exercise:

[**Use a non-root user**](../60-nonroot)

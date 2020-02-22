+++
categories = []
date = "2020-02-20"
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
Contact other services in the same namespace.
TODO additional

### Countermeasure
Move deployments into separate namespaces.

```
kubectl delete -f https://securek8s.dev/namespaces/default.yaml
```

Try to create a split-up version (with a mistake!):

```
kubectl apply -f https://securek8s.dev/namespaces/split.yaml
```

This will fail because we're accidentally mounting a secret, and now it's over a namespace boundary.
So let's deploy a fixed version:

```
kubectl apply -f https://securek8s.dev/namespaces/split-no-mount.yaml
```

### Attack effects after patching
Some network accesses are no longer accidentally allowed by policy.
TODO additional

### How to use it yourself
`kubectl create ns <your-namespace>` (or use a YAML, as shown in the example).

Then include `namespace: <your-namespace>` in the `meta` for your object.

After that, use the `-n` argument in commands, for example:
`kubectl get all -n <your-namespace>`.

### Next up
We'll cover the use of non-root user identities in the next exercise:

[**Use a non-root user**](../60-nonroot)

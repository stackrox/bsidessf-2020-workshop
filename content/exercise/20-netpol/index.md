+++
categories = []
date = "2020-02-22"
description = ""
slug = ""
tags = []
title = "Network policies"
draft = false
toc = true
weight = 20
+++

### Introduction
In this exercise, we cover:

 - Interesting types of access that pods have
 - How you can effectively limit network access

### Setup
We'll use an application that simulates a Server Side
Request Forgery (SSRF), like the one involved in the Shopify
bug bounty report, which ultimately allowed an adversary to
steal cloud credentials from the metadata server.

We'll use the simulated SSRF to see what a real problem
like this could expose.

First, let's take a look at the app. You can use the Cloud Shell
editor, or the terminal:

```
less static/ssrf/main.go
```

{{< embedCodeFile file="/static/ssrf/main.go" language="go" >}}

Then let's check out the Dockerfile, which is quite simple:
```
less static/ssrf/Dockerfile
```

{{< embedCodeFile file="/static/ssrf/Dockerfile" language="docker" >}}

This is an example of using the `scratch` base image, which has effectively nothing in it.
Other similar options include "distroless" containers, or container-focused minimal OSes.

Then, let's deploy:

```
kubectl apply -f https://securek8s.dev/ssrf/base.yaml
```

The service is deployed on a NodePort on port 30001. Open it in your browser by running:

```
open "http://${WORKSHOP_NODE_IP:-localhost}:30001"
```

or create a new browser tab directly.

### Attack
We'll use the fake SSRF exploit to access:

 - The cloud provider metadata server
     - `/fetch?url=http://169.254.169.254`
     - See what you can find in there!
 - The Kubernetes API
     - `/fetch?url=https://kubernetes.default`
 - The kubelet read-only API
     - `/fetch?url=http://169.254.123.1:10255/pods`
     - What do you see in there?
 - The Struts service we deployed earlier
     - `/fetch?url=http://struts.struts:30003`

### Countermeasure
We'll apply an egress NetworkPolicy that blocks access to these services.

See what's changed:

```
kubectl diff -f https://securek8s.dev/ssrf/egress-disabled.yaml
```

Now deploy:

```
kubectl apply -f https://securek8s.dev/ssrf/egress-disabled.yaml
```

We'll see how this egress policy allows us to contact our app from the outside, but doesn't let adversaries reach *back out from inside* to download tools.
(Kubernetes policies apply to connections--not to packets.)

To do this, just try the examples above again.

### Attack effects after patching
The adversary won't be able to use your app's network connection
to reach out to the Internet or to underlying infrastructure.

If an adversary can run code or cause network requests in your
pods, they will have a harder time finding out more about your
infrastructure or spreading through it.

### How to use it yourself
Include Network Policy YAMLs in your deployment tooling.
Some people have success starting with ingress rules, and
applying them to the most sensitive services first; once
that rhythm is established, you can move on to the rest.

Check out these posts for more details:

 - [Ingress policies guide](https://www.stackrox.com/post/2019/04/setting-up-kubernetes-network-policies-a-detailed-guide/)
 - [Egress policies guide](https://www.stackrox.com/post/2020/01/kubernetes-egress-network-policies/)

### Next up
We'll move on to Kubernetes service accounts and RBAC in the next exercise:

[**Tune Kubernetes RBAC and account provisioning**](../30-sa-token)

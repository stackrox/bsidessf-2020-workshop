+++
categories = []
date = "2020-02-20"
description = ""
slug = ""
tags = []
title = "Streamlined images"
draft = false
toc = true
weight = 2
+++

### Introduction
In this use case, we cover:

 - Removing unnecessary tools from an image
 - Changing the base image to a slimmer one

### Setup
We'll use an image with application-level vulnerabilities.
This is a common case for both in-house applications and those
that use common components. For example, Apache Struts is a
framework that has had well-known exploitable vulnerabilities
in the past.

For this example, we won't have applied other controls already;
many people tackle image security first, so this lets us see the
impact of minimal images without other controls keeping
adversaries isolated or at bay.

Check out the base Dockerfile before we continue:

```
less apps/struts/Dockerfile
```

Now, deploy the application:

```
kubectl create -f https://securek8s.dev/struts/base.yaml
```

Wait for it to deploy:

```
kubectl get pod -n struts-bad -w
```

### Attack
Use a canned exploit that launches a shell, downloads a cryptominer,
and runs it.

```
apps/struts/attack struts-bad "$(./utils/get-node-extip):30003"
```

😱

### Countermeasure
First, we'll update to a new image without common tools.

Deploy the streamlined app:

```
kubectl apply -f https://securek8s.dev/struts/streamlined.yaml
```

Wait for it to deploy:

```
kubectl get pod -n struts-bad -w
```

Then we'll attack it:

```
apps/struts/attack struts-bad "$(./utils/get-node-extip):30003"
```

### Attack effects after patching
The adversary is annoyed by your minimal environment and has to
come up with another way of installing code... or they move on to
another target!

### How to use it yourself
During the workshop, we'll only compare Dockerfiles and
patch deployments to use different images, but you could
apply similar techniques in images you build yourself.

_Note:_ If you want to use Alpine Linux, note that Alpine uses
musl libc, which is occasionally different from glibc in
important ways. DNS behavior is a particularly surprising one
to troubleshoot at runtime. There are many articles and issues;
see, e.g., [this one about Python](https://pythonspeed.com/articles/alpine-docker-python/).

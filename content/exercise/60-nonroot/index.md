+++
categories = []
date = "2020-02-20"
description = ""
slug = ""
tags = []
title = "Use a non-root user"
draft = false
toc = true
weight = 60
+++

### Introduction
In this use case, we cover:
 - How user identities work in Kubernetes
 - How to use a non-root user ID and enforce this in the future

### How to use it yourself
TODO verify effects of each part

change image
set runAsNonRoot in pod
require runAsNonRoot in PSP or AC

Note that most clusters run without username remapping,
so generally the container root identity is the same as the host root.

### Setup
For simplicity, we'll use a shell directly in this case.

We will show how running as root:
 - Is the default behavior
 - Lets you modify host files if mounted
 - Allows other host modifications
 - Still blocks other host modifications due to other controls
   (more on this in the following exercise)

### "Attack"
`echo "169.254.169.254 example.com" >> /host/etc/hosts`

### Countermeasure
First, we'll set `runAsNonRoot` in the pod's `securityContext`.
This will prevent anyone from accidentally running the container as root.

Then we'll change to an image that's been prepared to run as non-root. We'll show how this can still be exposed using a Service.

### Attack effects after patching
Can't do what they wanted to!

### References
[Runtimes and Curse of the Privileged Container](https://brauner.github.io/2019/02/12/privileged-containers.html) in LXC and LXD.

[A container-confinement breakout](https://lwn.net/Articles/781013/) in runC (and runtimes that rely on it, including Docker, Podman, CRI-O, and containerd).

(Note that these articles define privileged containers as
"a container where the semantics for id 0 are the same inside and outside of the container ceteris paribus"--
this is not the same as the `--privileged` option in Docker.)

[Running non-root containers on OpenShift](https://engineering.bitnami.com/articles/running-non-root-containers-on-openshift.html) and associated [documentation](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/)

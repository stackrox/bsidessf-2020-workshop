+++
categories = []
date = "2020-02-22"
description = ""
slug = ""
tags = []
title = "Streamlined images"
draft = false
toc = true
weight = 2
+++

### Introduction
In this exercise, we cover:

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
less static/struts/Dockerfile
```

{{< embedCodeFile file="/static/struts/Dockerfile" language="docker" >}}

Now, deploy the application:

```
kubectl apply -f https://securek8s.dev/struts/base.yaml
```

Wait for it to deploy:

```
kubectl get pod -n struts -w
```

You're ready to move on once your pod is marked `Running`.

### Attack
Use a canned exploit that launches a shell, downloads a cryptominer,
and runs it.

```
static/struts/attack struts "$(./utils/get-node-extip):30003"
```

(If you haven't cloned the workshop repository, {{< downloadLink file="/static/struts/attack" prompt="download the attack script" >}}, make it executable by running `chmod +x attack`, then run it.)

If the connection and exploit succeed, you'll see the cryptominer process running, something like:

```
Processes running:
    PID COMMAND
      1 java
     62 minerd
```

😱

### Countermeasure
We'll update to a new image with some common tools removed, mostly via a slimmer base image.

Check out what's different in the Dockerfile:

```bash
diff static/struts/Dockerfile static/struts/Dockerfile-streamlined
```

{{< embedCodeFile file="/static/struts/streamlined.patch" language="diff" >}}

And [see the difference between image versions in Quay.io](https://quay.io/repository/connorg/struts?tab=tags).

Then, deploy the streamlined app:

```
kubectl apply -f https://securek8s.dev/struts/streamlined.yaml
```

Wait for it to deploy:

```
kubectl get pod -n struts -w
```

You're ready to move on when your new pod (with a smaller `AGE` value) is `Running`,
and the older pod is `Terminating`.

Then we'll attack the new one:

```bash
static/struts/attack struts "$(./utils/get-node-extip):30003"
```

You'll see an error from the same injected command we ran earlier:

```
sh: 1: wget: not found
```

👍

That's because we've removed `wget`.

### Attack effects after patching
The adversary is annoyed by your minimal environment and has to
come up with another way of installing code... or, if you're lucky,
they move on to another target!

### How to use it yourself
During the workshop, we'll only compare Dockerfiles and
patch deployments to use different images, but you could
apply similar techniques in images you build yourself.

_Note:_ If you want to use Alpine Linux, note that Alpine uses
musl libc, which is occasionally different from glibc in
important ways. DNS behavior is a particularly surprising one
to troubleshoot at runtime. There are many articles and issues;
see, e.g., [this one about Python](https://pythonspeed.com/articles/alpine-docker-python/).

### Next up
We'll apply a different lock-down to this app in the next exercise:

[**Use a read-only root file system**](../10-ro-fs)

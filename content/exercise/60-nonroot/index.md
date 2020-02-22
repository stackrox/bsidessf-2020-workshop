+++
categories = []
date = "2020-02-22"
description = ""
slug = ""
tags = []
title = "Use a non-root user"
draft = false
toc = true
weight = 60
+++

### Introduction
In this exercise, we cover:

 - How user identities work in Kubernetes
 - How to use a non-root user ID and enforce this in the future

We will show how running as root:

 - Is the default behavior
 - Lets you modify host files if mounted
 - Allows other host modifications
 - Still blocks other host modifications due to other controls
   (more on this in the following exercise)

Note that almost all clusters run without username remapping,
so generally the `root` user in the container is the same as the `root` user on the host.

### Setup
For simplicity, we'll use a shell directly in this case.

Before we deploy, let's see what this app does.
Use the Cloud Shell Editor, or open the code your terminal:

```
less apps/simple-server/main.go
less apps/simple-server/Dockerfile
```

Let's get deployed:

```
kubectl apply -f https://securek8s.dev/simple-server/app.yaml
```

### "Attack"
Let's find a pod:

```
kubectl get po -n nonroot
```

And exec into it:
```
kubectl exec -it -n nonroot <pod> sh
```

_Note:_ We're using `sh` now because this is an Alpine image.

Check who you are:
```
whoami
```

Then, we can do a variety of things to the host, because we're running as root:
```
echo "169.254.169.254 example.com" >> /host/etc/hosts
cat /host/etc/hosts
```

Can you think of anything else?

### Countermeasure
First, we'll set `runAsNonRoot` in the pod's `securityContext`.
This will prevent anyone from accidentally running a container as root.

See the diff:
```
kubectl diff -f https://securek8s.dev/simple-server/app-not-allowed.yaml
```

Note that we haven't bumped the image to _actually_ use a non-root user—a common mistake.

Then, roll out the change:
```
kubectl apply -f https://securek8s.dev/simple-server/app-not-allowed.yaml
```

You'll see that the pods are failing to create:
```
kubectl get pod -n nonroot
```

The error is `Error: container has runAsNonRoot and image will run as root`.
As a result, our old deployment config is still active.

Next, we'll change to an image that's _actually_ been prepared to run as non-root.
We'll see how this can still be exposed on the same port using a Service, even though thee container has switched from 80 to 8080.

See the diff in the Dockerfile:
```
diff apps/simple-server/Dockerfile apps/simple-server/Dockerfile-nonroot
```

...and in the YAML:
```
kubectl diff -f https://securek8s.dev/simple-server/app-nonroot.yaml
```

Then, roll out the change:
```
kubectl apply -f https://securek8s.dev/simple-server/app-nonroot.yaml
```

Our change successfully rolls out:
```
kubectl get pod -n nonroot -w
```

### Attack effects after patching
Once we successfully run as a non-root user, we are a bit more constrained in what we can do to the host. If we repeat our attempts to modify `/host/etc` we will fail.

### How to use it yourself
In most cases, you'll need at least a simple modification to your `Dockerfile` to set the non-root user ID.
In some cases, the app may need more substantial changes.

You can set the `runAsNonRoot` flag in your pod spec to prevent accidentally running as root.

You can also require `runAsNonRoot` using admission control.

### References
- [Runtimes and Curse of the Privileged Container](https://brauner.github.io/2019/02/12/privileged-containers.html) in LXC and LXD.

- [A container-confinement breakout](https://lwn.net/Articles/781013/) in runC (and runtimes that rely on it, including Docker, Podman, CRI-O, and containerd).
  Note that these articles define privileged containers as
"a container where the semantics for id 0 are the same inside and outside of the container ceteris paribus"--
this is not the same as the `--privileged` option in Docker.

- [Running non-root containers on OpenShift](https://engineering.bitnami.com/articles/running-non-root-containers-on-openshift.html) and associated [documentation](https://docs.bitnami.com/containers/how-to/work-with-non-root-containers/)

### Next up
We'll cover the `--privileged` mode in the next exercise:

[**Avoid privileged mode**](../65-privileged)

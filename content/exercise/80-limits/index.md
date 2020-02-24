+++
categories = []
date = "2020-02-22"
description = ""
slug = ""
tags = []
title = "Set resource limits"
draft = false
toc = true
weight = 80
+++

### Introduction
In this exercise, we cover:

 - How to set resource limits
 - What can happen if you don't

_Note:_ This exercise needs a little bit of work, at least to use in Cloud Shell. It'll be updated soon.

### Setup
In this example, we'll use an app with an exploitable
memory exhaustion denial of service. This will be fun to watch...

We'll use something sort of like a "Billion Laughs"-style attack. Here's the example
from [Kubernetes CVE-2019-11253](https://github.com/kubernetes/kubernetes/issues/83253):
```
apiVersion: v1
data:
  a: &a ["web","web","web","web","web","web","web","web","web"]
  b: &b [*a,*a,*a,*a,*a,*a,*a,*a,*a]
  c: &c [*b,*b,*b,*b,*b,*b,*b,*b,*b]
  d: &d [*c,*c,*c,*c,*c,*c,*c,*c,*c]
  e: &e [*d,*d,*d,*d,*d,*d,*d,*d,*d]
  f: &f [*e,*e,*e,*e,*e,*e,*e,*e,*e]
  g: &g [*f,*f,*f,*f,*f,*f,*f,*f,*f]
  h: &h [*g,*g,*g,*g,*g,*g,*g,*g,*g]
  i: &i [*h,*h,*h,*h,*h,*h,*h,*h,*h]
kind: ConfigMap
metadata:
  name: yaml-bomb
  namespace: default
```

The example app just allocates memory based on the value of the parameter you give it.

View the code:

```
less apps/memory-exploder/main.go
```

Then deploy:
```
kubectl apply -f https://securek8s.dev/memory-exploder/buggy.yaml
```

### "Attack"
Call the bad method:
```
curl -X POST http://$(utils/get-node-extip):30002/1234
```

This will work. But bump up the number and it will start getting bad!

```
curl -X POST http://$(utils/get-node-extip):30002/123456789012345
```

You can exit from the request and try to run `kubectl top` to see the pod fall over.

(Note: for the purposes of the workshop, we won't try to make
nodes completely fall over...)

### Countermeasure
Apply a memory and CPU limit.

See the diff:

```
kubectl diff -f https://securek8s.dev/memory-exploder/buggy-but-limited.yaml
```

Then deploy:

```
kubectl diff -f https://securek8s.dev/memory-exploder/limited.yaml
```

### Attack effects after patching
The app gets OOMKilled and restarted instead of causing nodes to
become unstable or crash.

### How to use it yourself
Add requests and limits to each of your pods.

Be careful about what you choose, especially for limits.
Too low a CPU limit can interfere with app functionality, especially if you do things like RSA.
Too low a memory limit will get your app OOMKilled repeatedly.

### Next up
We'll cover effective metadata in the next exercise:

[**Bonus: Apply good, consistent metadata**](../90-metadata)

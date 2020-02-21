+++
categories = []
date = "2020-02-20"
description = ""
slug = ""
tags = []
title = "Set resource limits"
draft = false
toc = true
weight = 80
+++

### Introduction
In this use case, we cover:
TODO

### How to use it yourself
TODO

### Setup
In this example, we'll use an app with an exploitable
memory exhaustion denial of service. This will be fun to watch...

We'll use a "Billion Laughs"-style attack. Here's the example
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

### "Attack"
Run `kubectl top`.
Call the bad method.
(Note: for the purposes of the workshop, we won't try to make
nodes completely fall over...)

### Countermeasure
Apply a memory and CPU limit.

### Attack effects after patching
The app crashes and restarts instead of causing nodes to
become unstable or crash.

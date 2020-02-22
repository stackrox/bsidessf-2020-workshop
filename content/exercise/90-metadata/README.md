+++
categories = []
date = "2020-02-22"
description = ""
slug = ""
tags = []
title = "Bonus: Apply good, consistent metadata"
draft = false
toc = true
weight = 90
+++

### Introduction
In this exercise, we cover:

 - What you can tag objects with in Kubernetes
 - How this is helpful if you have to debug an issue or incident

### Setup
Deploy the example YAML without metadata.

### "Attack"
N/A--but we'll take a look at what we can query here
using Kubernetes labels. (Hint: nothing really useful!)

### Countermeasure
Add metadata.

### Attack effects after patching
Now we can use label filters. Neat!

`kubectl get deploy -l app=server -n meta`

`kubectl get deploy -l team=backend-dataproc -n meta`

### How to use it yourself
Decide on a scheme. Then, apply labels and annotations
in the `meta` part of your YAMLs.

Note that, if you want to apply labels to pods, you have to
put them in your pod template, not just on the Deployment
or other higher-level object.

### Next up
All done for now! 🙂

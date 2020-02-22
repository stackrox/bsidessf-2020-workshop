+++
categories = []
date = "2020-02-20"
description = ""
slug = ""
tags = []
title = "Use separate namespaces"
draft = false
toc = true
weight = 50
+++

### Introduction
In this exercise, we cover:

 - What namespaces are
 - How various types of Kubernetes objects treat namespace boundaries

### How to use it yourself
`kubectl create ns <your-namespace>` (or use a YAML, as shown in the example).

Then include the namespace name in the `meta` for your object.

After that, use the `-n` argument in commands, for example:
`kubectl get all -n <your-namespace>`.

### Setup
In this example, we'll use shells inside of apps to see
how they can talk to one another.
We'll also intentionally make some mistakes and see if
Kubernetes tells us we did something wrong.

<!-- TODO: Include a graph of the services. It can get complicated! -->

### "Attack"
Contact other services in the same namespace.
TODO additional

### Countermeasure
Move deployments into separate namespaces.

### Attack effects after patching
Some network accesses are no longer accidentally allowed by policy.
TODO additional

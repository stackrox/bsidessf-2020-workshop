+++
categories = []
date = "2020-02-20"
description = ""
slug = ""
tags = []
title = "Read-only root file system"
draft = false
toc = true
weight = 10
+++

### Introduction
In this use case, we cover:
 - How to mark the root of your container read-only
 - How to make certain paths writable if you need to

### How to use it yourself
Use the [`SecurityContext`](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.15/#securitycontext-v1-core)
field called `readOnlyRootFilesystem`.

If you need a writable path, use a `VOLUME` instruction
(if you deploy only on clusters or machines running Docker)
or mount a Kubernetes `emptyDir` if you want a solution that
works on other runtimes (especially CRI-O).
<!-- TODO: add reference to CRI-O bug ticket -->

### Setup
We'll use the same image as before, because app vulnerabilities
are useful to demonstrate attacks!

We'll start with a writable file system and show how useful
that is for an adversary.

### Attack
Use a canned exploit to launch a shell, download new code,
and run it.

(We just did this with the initial Struts image; remember?)

### Countermeasure
Update the deployment YAML to request a read-only root filesystem,
and mark a necessary path as writable.

### Attack effects after patching
The attack fails to modify the running container.
While this is still a problem--you don't want them in your
container anyway!--at least they are more constrained and
have to find other ways to accomplish their goals.

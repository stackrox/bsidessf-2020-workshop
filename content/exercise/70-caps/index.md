+++
categories = []
date = "2020-02-20"
description = ""
slug = ""
tags = []
title = "Minimize Linux capabilities"
draft = false
toc = true
weight = 70
+++

### Introduction
In this exercise, we cover:

 - How Linux capabilities work
 - How to drop various capabilities in your apps

### How to use it yourself
use the capabilities field in the pod securitycontext (container??) rather than privileged mode

to know what caps you need, consider "capable"

remember that all of these changes should go through CI and testing

### Setup
We'll exec directly into a container in this example.

TODO kubectl create with default caps + one added

### "Attack"
Once we are in this shell, we can do some fun stuff to explore what we can do.

TODO Try a bunch of stuff, like ping and sudo in the container

### Countermeasure
Drop unnecessary capabilities

### Attack effects after patching
Can't do what they wanted to
TODO

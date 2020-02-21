+++
categories = []
date = "2020-02-20"
description = ""
slug = ""
tags = []
title = "Streamlined images"
draft = false
toc = true
weight = 1
+++

### Introduction
In this use case, we cover:
 - Removing unnecessary tools from an image
 - Changing the base image to a slimmer one

### How to use it yourself
During the workshop, we'll only compare Dockerfiles and
patch deployments to use different images, but you could
apply similar techniques in images you build yourself.

N.B.: If you want to use Alpine Linux, note that Alpine uses
musl libc, which is occasionally different from glibc in
important ways. DNS behavior is a particularly surprising one
to troubleshoot at runtime. There are many articles and issues;
see, e.g., https://pythonspeed.com/articles/alpine-docker-python/.

### Setup
We'll use an image with application-level vulnerabilities.
This is a common case for both in-house applications and those
that use common components. For example, Apache Struts is a
framework that has had well-known exploitable vulnerabilities
in the past.

For this example, we won't have applied other controls already;
many people tackle image security first, so this lets us see the
impact of minimal images without other controls keeping
adversaries isolated or at bay.

### Attack
Use a canned exploit to launch a shell, download new code,
and run it.

### Countermeasure
Update to a new image without common tools.

### Attack effects after patching
The adversary is annoyed by your minimal environment and has to
come up with another way of installing code... or they move on to
another target!

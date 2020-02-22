+++
categories = []
date = "2020-02-20"
description = ""
slug = ""
tags = []
title = "Network policies"
draft = false
toc = true
weight = 20
+++

### Introduction
In this exercise, we cover:

 - Interesting types of access that pods have
 - How you can effectively limit network access

### How to use it yourself
Include Network Policy YAMLs in your deployment tooling.
Some people have success starting with ingress rules, and
applying them to the most sensitive services first; once
that rhythm is established, you can move on to the rest.

We'll cover more of the details, because simply denying
all egress (as we do in this example) isn't tenable in
many cases.

### Setup
We'll use an application that simulates a Server Side
Request Forgery (SSRF), like the one involved in the Shopify
bug bounty report, which ultimately allowed an adversary to
steal cloud credentials from the metadata server.

We'll use the simulated SSRF to see what a real problem
like this could expose.

We'll also see how this egress policy allows us to contact
our Struts-vulnerable app, but doesn't let adversaries
reach *back out* to download tools. (Kubernetes policies
apply to connections--not to packets.)

### Attack
Use the fake SSRF exploit to access:
 - The cloud provider metadata server
 - The Kubernetes API
 - The kubelet read-only API

Also, try our Struts exploit out again.

### Countermeasure
Apply an egress NetworkPolicy that blocks access to these services.

### Attack effects after patching
The adversary won't be able to use your app's network connection
to reach out to the Internet or to underlying infrastructure.

If an adversary can run code or cause network requests in your
pods, they will have a harder time finding out more about your
infrastructure or spreading through it.

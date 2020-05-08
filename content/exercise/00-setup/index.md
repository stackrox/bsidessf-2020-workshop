+++
categories = []
date = "2020-02-22"
description = ""
slug = ""
tags = []
title = "Setup"
draft = false
toc = true
weight = 1
+++

To complete the exercises, you'll need:
- a Kubernetes cluster, and
- a command-line terminal with the [`kubectl`](https://kubernetes.io/docs/tasks/tools/install-kubectl/) client.

### Get a cluster
If you're completing these exercises on your own, you'll need to provide your own cluster.
Here are a few ways to get a cluster running:
- Install [Docker for Mac](https://docs.docker.com/docker-for-mac/) or [Docker for Windows](https://docs.docker.com/docker-for-windows/) and enable Kubernetes.
  - On Windows, keep the default setting so you can run Linux containers. [Switch back to Linux](https://docs.docker.com/docker-for-windows/#switch-between-windows-and-linux-containers) if you currently use Windows containers.
- Install [Minikube](https://kubernetes.io/docs/setup/learning-environment/minikube/).
- [Create a cluster in Google Kubernetes Engine (GKE)](https://cloud.google.com/kubernetes-engine/docs/quickstart) or a similar managed Kubernetes service.
- Use another tool to create a cluster.

You can do all the exercises with a CPU core or two; one node should work fine.

Your cluster needs to meet a few requirements:
- For some exercises, Network Policies must be enabled in the cluster.
    - Depending on where and how you're building your cluster, you may have to set a configuration option when you create your cluster or complete an upgrade later.
    - For example, in GKE, you'd use the [`--enable-network-policy`](https://cloud.google.com/sdk/gcloud/reference/container/clusters/create#--enable-network-policy) option.
- You'll need to be able to access services using [NodePort service](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport), if you want to use the exercises without making your own modifications.
    - In some environments, like clouds, you may have to create a firewall rule to allow your machine to access ports in the 30000-30010 range.
    - If you can't expose NodePort services, you can create port-forwards. However, you may have to restart them after you replace pods in certain exercises.
- Your cluster nodes must be able to pull publicly available images from Docker Hub.

#### Be responsible
Do not use:
- anyone else's cluster,
- any cluster that runs real workloads, or
- any cluster you are not specifically allowed to deploy vulnerable services into.

If you aren't sure, check first.

These exercises intentionally introduce vulnerable services into your cluster.
(And besides that, the exercises may not work as well if you have a lot of other workloads or configurations.)

<!--
#### Getting a cluster in a hosted workshop
1. Right-click the button below, choose "Open in New Tab", and sign in.
   [![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?project=bsides-workshop&cloudshell=true&cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fstackrox%2Fbsidessf-2020-workshop&cloudshell_print=live-workshop%2Fwelcome.txt&cloudshell_open_in_editor=apps%2F)

1. Select **Continue** if Google shows you an introduction to Cloud Shell.

1. Select **Confirm** when asked about cloning this repository.

1. Select **Open in Editor** if asked about opening the editor.
-->

### See the materials
You can see the materials for each exercise on the site, and the `kubectl` commands download files straight from the site so you don't need to have them on your machine.

However, if you do clone [the GitHub repository](https://github.com/stackrox/bsidessf-2020-workshop) for this site, you'll get a few extra scripts and you'll be able to view files in your own editor instead of your browser.

### Set your node IP
To complete the exercises without modifying them yourself, you'll need to be able to access your cluster by using [**NodePort**](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) services.

The exercises use hardcoded NodePort numbers for simplicity.
If you're running other applications in your cluster, or you've customized your [NodePort range](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport), you may need to modify the examples.

The examples use a variable, `WORKSHOP_NODE_IP`, that defaults to `localhost`.

 - If you're using a local setup like Docker for Mac, `localhost` should work.
 - If you're using a different type of cluster, you may have to set a value for `WORKSHOP_NODE_IP`.

```bash
export WORKSHOP_NODE_IP="<your-ip-or-hostname>"
```

#### "Smoke test"
Use the smoke-test deploy to make sure you can access services.
If you can't access the smoke-test, the server-based deploys probably won't work, though you can follow along with most of the other exercises.

```bash
kubectl create -f https://securek8s.dev/smoke-test/deploy.yaml
```

You should be able to see the "Welcome to nginx!" page on port 30000 on your `WORKSHOP_NODE_IP`:

```bash
open "http://${WORKSHOP_NODE_IP:-localhost}:30000"
```

If this doesn't work, check the output of `kubectl describe node` or:
```
kubectl get node -o wide
```
to see if other listed IPs or hostnames work.

If you're running in a cloud, you'll usually need to add a firewall rule that allows traffic to the NodePort range (at least ports 30000-30005 for these examples) on your cluster nodes.

### Next up
Get started!

[**Use streamlined images**](../01-streamline-image/)

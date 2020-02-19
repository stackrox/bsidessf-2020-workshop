## Read-only root file system

### Introduction
In this use case, we cover:
 - The risk of host mounts
 - How to use read-only mounts if they suffice

### How to use it yourself
If you use an application that needs to know something about the host,
you might need to mount a host path.

You can minimize the risk that such mounts poses by:
 - marking them read-only, and
 - minimizing the mount surface to just what's required.

 Note: container runtimes will sometimes _create_ files on your host
 if they do not exist, which can be a problem if you want to mount
 a path that might not exist yet.
 This is particularly annoying when you try to mount a specific file
 and the runtime creates a directory.

### Setup
In this example, we'll just directly use a shell inside the app.
Our example app will be a simulated monitoring agent mounting the same paths as the [Datadog DaemonSet](https://docs.datadoghq.com/agent/kubernetes/daemonset_setup/?tab=k8sfile):
```
volumeMounts:
  - {name: dockersocket, mountPath: /var/run/docker.sock}
  - {name: procdir, mountPath: /host/proc, readOnly: true}
  - {name: cgroups, mountPath: /host/sys/fs/cgroup, readOnly: true}
  - {name: s6-run, mountPath: /var/run/s6}
  - {name: logpodpath, mountPath: /var/log/pods}
  ## Docker runtime directory, replace this path with your container runtime
  ## logs directory, or remove this configuration if `/var/log/pods`
  ## is not a symlink to any other directory.
  - {name: logcontainerpath, mountPath: /var/lib/docker/containers}
```

We'll also mount `/etc` itself for extra fun.

<!-- TODO: note that you read env vars with this mount, even if read-only. Also, the Docker socket—scream! -->

### Attack
With our power to execute commands, we'll see what types of files we
could modify, and what sorts of access they could provide.

### Countermeasure
We'll:
 - Remove some mount paths our application doesn't need,
 - Mark some of our mounts read-only, and
 - Mount more specific paths,
depending on the access we actually need.

### Attack effects after patching
Can't mess with stuff if you can't write to it, or
find out information you can't read!

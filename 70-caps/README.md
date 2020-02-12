## Use a non-root user

### Introduction
In this use case, we cover:
 - How Linux capabilities work
 - How to drop various capabilities in your apps

### How to use it yourself
use the capabilities field in the pod securitycontext (container??)
TODO

to know what caps you need, consider "capable"

remember that all of these changes should go through CI and testing

### Setup
We'll exec directly into the container since that's easier.

Note that we're starting with the default profile.

### "Attack"
Try a bunch of stuff, like ping and sudo.
TODO

### Countermeasure
Drop unnecessary capabilities

### Attack effects after patching
Can't do what they wanted to
TODO

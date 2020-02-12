## Use a non-root user

### Introduction
In this use case, we cover:
 - What `--privileged` mode does
 - The crazy things it allows
 - How you might be able to replace it
TODO

TODO combine with caps example? lots of overlap in what you do to fix it

### How to use it yourself
use the capabilities field in the pod securitycontext (container??) rather than privileged mode

to know what caps you need, consider "capable"

remember that all of these changes should go through CI and testing

### Setup
We'll exec directly into the container since that's easier.

### "Attack"
Explore the host and 
TODO

### Countermeasure
Drop unnecessary capabilities

### Attack effects after patching
Can't do what they wanted to
TODO

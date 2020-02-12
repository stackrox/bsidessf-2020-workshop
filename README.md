This content supports a live workshop at BSidesSF 2020:
"Using Built-in Kubernetes Controls to Secure Your Applications".

The workshop includes some extra introduction and conclusion content,
but centers around these workshop examples.

Each case will typically follow a common structure:
 - **Presenter:** a short introduction on how the control works (2 minutes)
 - **Attendees:** run a deployment with the default configuration
 - **Attendees:** attack the default configuration
      - Note: be clear if this is an out-of-the box default (e.g. no netpols), something particular to one environment (e.g. no CNI provider), or a contrived “mistake” (e.g. cluster admin)
 - **Presenter:** explain what we can do to change the default (1-2 minutes)
 - **Attendees:** apply a patch
 - **Attendees:** repeat attack and be sad (or happy!) it is stopped

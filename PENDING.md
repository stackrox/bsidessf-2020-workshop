Overall:
 - Run through everything
 - Capture expected output
 - Clean up port numbers
 - Create GKE clusters
 - Configure user access
 - Pre-stage firewall rules for nodeports
 - Renumber examples once finalized
 - Show diffs between files. (Include commands for that?)

 - Host static manifests; use them in commands

20-netpol:
 - Update to specify not blocking _all_ egress

50-ns:
 - Update steps

70-caps:
 - write it

90-metadata:
 - Write silly examples with tons of labels

100-exposure:
 - Create GKE internal-only LB annotation
 - Show GKE firewall rules annotation
 - Show downgrading LB to NP or ClusterIP or port-forward

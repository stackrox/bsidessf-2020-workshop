Overall:
 - Run through everything
 - Capture expected output
 - Clean up port numbers
 - Set up GCP project, GKE clusters, and user access
 - Pre-stage firewall rules for nodeports
 - Renumber examples once finalized
 - Show diffs between files. (Include commands for that?)

50-ns:
 - Create apps with:
     - different namespaces
     - network policies
     - secrets that could be accidentally mounted

60-nonroot:
 - Consider combining with 65-privileged and 70-caps
 - For privileged, add Duffie's tweet-to-root

90-metadata:
 - Write silly examples with tons of labels

100-exposure:
 - Create GKE internal-only LB annotation
 - Show GKE firewall rules annotation
 - Show downgrading LB to NP or ClusterIP or port-forward

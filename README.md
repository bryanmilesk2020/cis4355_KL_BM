# cis4355_KL_BM

## Secure multi-tier web application

Goal: Design & deploy a multi-tier web application with a public-facing frontend, a private application backend, and a managed
database, all protected by a WAF and CDN.

## Services Used

| Service | Purpose |
| -------- | -------- |
| VPC Network | To host the VM instance and database instance |
| Cloud Load Balancer | Directs ingress traffic to either the VM instance or bucket |
| Compute Engine | To create a VM instance that handles user requests |
| Cloud SQL | To store any application data, independently from the VM instance |
| Cloud Storage | Create a bucket that can store static assets/heavy files, so the VM doesn't have to store them and operate more efficiently |
| Cloud CDN | Can handle any simple, repetitive requests, taking the load off the VM instance or bucket |
| Cloud Armor | Protects the VM, blocks traffic on all other ports, but checks who comes through http (port 80) | 
| Cloud IAM | Create users and service accounts with specific roles |
| Cloud Logging | Documents actions on VM instance |
| Secret Manager | Store the SQL database password, hardening the environment |

## Security Summary

We used GCP's Secret Manager to store and hash the database name, password, and database username so it doesn't have to be hardcoded on the backend code on the vm instance, adding an extra layer of security. We also configured a cloud armor policy, cis4355-waf-policy, to address or partially address some web attacks such as SQL injections, broken access control, and SSRF.

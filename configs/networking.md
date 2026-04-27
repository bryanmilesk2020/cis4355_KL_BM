# Networking

## VPC Network Configuration
**Name:** `cis4355-project-vpc`

### Private and Public Subnet Hierarchy

| Subnet Name | IP Range |
| :--- | :--- |
| sn-private-backend | `10.0.2.0/24` |
| sn-private-db | `10.0.3.0/24` |
| sn-public-frontend | `10.0.1.0/24` |
| proxy-only-subnet | `10.128.0.0/20` |

---

## Firewall Rules

| Name | Priority | Direction | Target Tags | IP Ranges | Protocols/Ports |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **allow-backend-to-sql-egress** | 10 | Egress | `backend-server` | `10.10.1.3/32` | `tcp:3306` |
| **allow-backend-port-5000** | 1000 | Ingress | `backend-server` | `0.0.0.0/0` | `tcp:5000` |
| **allow-backend-to-sql** | 1000 | Ingress | none | `10.0.2.0/24` | `tcp:3306` |
| **allow-lb-to-flask** | 1000 | Ingress | none | `130.211.0.0/22`, `35.191.0.0/16` | `tcp:5000` |
| **allow-ssh-from-iap** | 1000 | Ingress | none | `35.235.240.0/20` | `tcp:22` |
| **cis4355-allow-internal-traffic** | 1000 | Ingress | none | `10.0.1.0/24`, `10.0.2.0/24`, `10.0.3.0/24` | `all` |
| **cis4355-project-vpc-allow-custom** | 65534 | Ingress | none | `10.0.1.0/24`, `10.0.2.0/24`, `10.0.3.0/24` | `all` |
| **cis4355-project-vpc-allow-icmp** | 65534 | Ingress | none | `10.0.1.0/24` | `icmp` |

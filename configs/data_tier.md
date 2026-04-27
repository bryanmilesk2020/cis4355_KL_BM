## Database (Data Tier)

### Cloud SQL Instance Configuration
* **Version:** `MySQL 8.4.8` (Enterprise Edition)
* **Region:** `us-south1`
* **Internal IP:** `10.10.1.3`
* **Connectivity:** Private IP only (Public IP disabled)

### Database Name and User
| Property | Value |
| :--- | :--- |
| **Instance ID** | `cis4355-db-instance` |
| **Database Name** | `cis4355_db` |
| **User** | `mileski_user` |

### How Private IP Connectivity Was Established
**Configuration Details:**
* **VPC Network:** `cis4355-project-vpc`
* **VPC Peering:** `servicenetworking-googleapis-com`
* **Peered Service Network:** `servicenetworking`
* **IP Stack:** `IPv4`
* **Custom Routes:** Import & Export custom routes enabled

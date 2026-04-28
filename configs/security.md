## Security

### Cloud Armor Policy and Rules
* **Policy Name:** `cis4355-waf-policy`
* **Scope:** Applied to `cis4355-backend-service` (WAF Protection).
* **Purpose:** Filters incoming traffic at the edge before it reaches the `sn-private-backend` subnet.

### Secret Manager Secrets
| Secret Name | Purpose |
| :--- | :--- |
| `Db-name` | Stores the identifier for the MySQL database. |
| `Db-pass` | Stores the password for the database user. |
| `Db-user` | Stores the username authorized to access the database. |

### IAM and Runtime Configuration
* **IAM Role Granted:** `Secret Manager Secret Accessor`
* **Runtime Integration:** The VM instance was assigned the `Secret Manager Secret Accessor` role. This allows `main.py` to 
fetch database credentials dynamically at runtime, eliminating the need for hardcoded values in the source code.

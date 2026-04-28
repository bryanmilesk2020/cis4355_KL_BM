## IAM

### Service Account Details
**Service Account Name:** `web-app-backend-sa`

### Roles Assigned & Rationale

| Role | Purpose / Why |
| :--- | :--- |
| **Cloud SQL Client** | Grants the VM instance (via its service account) access to connect to the Cloud SQL instance. |
| **Compute Network Viewer** | Allows the account to view networking resources, configurations, and routes within the project. |
| **Logs Writer** | Enables the VM instance to write logs to Log Explorer, providing an audit trail external to the VM. |
| **Secret Manager Secret Accessor** | Enables the VM to fetch database credentials (ID, password, and user) at runtime, preventing hardcoding. |
| **Storage Object Viewer** | Allows the Flask app on the VM to reference and retrieve static assets stored in the Cloud Storage bucket. |

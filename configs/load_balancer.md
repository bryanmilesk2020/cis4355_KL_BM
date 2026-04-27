## Load Balancer

### General Info
* **Name:** `cis4355-lb`
* **Type:** Application Load Balancer (External)
* **Routing Rules:** Directs external HTTP traffic to the backend instance group running the Flask app.

### Frontend Configuration
| Property | Value |
| :--- | :--- |
| **Name** | `cis4355lb-frontend` |
| **Address** | `34.174.113.179:80` |
| **Protocol** | HTTP |
| **Region** | `us-south1` |

### Backend Configuration
| Property | Value |
| :--- | :--- |
| **Name** | `cis4355-backend-service` |
| **Protocol** | HTTP |
| **Region** | `us-south1` |
| **Health Check** | `flask-health-check:5000` |

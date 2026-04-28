## Compute (Application Tier)

### Backend VM Specs
* **Machine Type:** `e2-micro`
* **Zone:** `c`
* **Region:** `us-south1` (Dallas)
* **Internal IP:** `10.0.2.2`

### Flask App Setup and Dependencies
**How to start the app:**
1. Click **SSH** to open up a terminal.
2. Type `cd backend`
3. Type `source venv/bin/activate`
4. Type `python3 main.py` to run the backend code.

### Instance Group Configuration
| Property | Value |
| :--- | :--- |
| **Name** | `backend-instance-group` |
| **Group Type** | Unmanaged |
| **Location** | `us-south1-c` |
| **In use by** | `cis4355-backend-service` |

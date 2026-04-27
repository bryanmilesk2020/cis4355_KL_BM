Compute (Application Tier)
Backend VM Specs
machine type: e2-micro
zone: c
region: us-south1 (dallas)
internal ip: 10.0.2.2
Flask app setup and dependencies
How to start the app
click ‘ssh’ to open up a terminal
type ‘cd backend’
type ‘source venv/bin/activate’
type ‘python3 main.py’ to run the backend code
Instance Group Configuration
name: backend-instance-group
group type: unmanaged
location: us-south1-c
in use by: cis4355-backend-service

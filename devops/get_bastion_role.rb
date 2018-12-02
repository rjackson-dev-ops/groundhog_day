# This command run on your bastion will give you a role you can assign to other EC2 instances for testing.
# You will need to assign a role to access any EC2 services
curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/
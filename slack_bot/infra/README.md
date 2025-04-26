# Slack Bot Infrastructure

This folder contains Terraform code to deploy the Slack bot infrastructure separately from the Bedrock agent.

- Use `main.tf`, `variables.tf`, and `terraform.tfvars` to define and configure the infrastructure (e.g., Lambda, API Gateway, IAM roles).
- The bot code lives in `../src` and should be packaged and deployed as needed.

## Typical Resources
- AWS Lambda (for the bot server)
- API Gateway (to receive Slack events)
- IAM roles and permissions

## Usage
1. Edit the Terraform files to match your deployment needs.
2. Deploy with `terraform init && terraform apply`.
3. Update your Slack app's event subscription URL to the deployed API Gateway endpoint.

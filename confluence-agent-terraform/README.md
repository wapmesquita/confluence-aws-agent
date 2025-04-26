# Confluence Bot Terraform Infrastructure

This project provides Terraform configurations for deploying an AWS Bedrock-powered Confluence knowledge base and agent. It sets up the necessary infrastructure to create an AI-powered bot that can interact with your Confluence content.

## Architecture Components

The infrastructure consists of the following main components:

- Amazon Bedrock Knowledge Base connected to Confluence
- Amazon Bedrock Agent for interacting with the knowledge base
- S3 bucket for storing knowledge base data
- IAM roles and policies for Bedrock services
- AWS Secrets Manager for storing Confluence credentials

## Project Structure

- **main.tf**: Core infrastructure including S3 bucket, IAM roles, and secrets management
- **variables.tf**: Input variables for customizing the deployment
- **outputs.tf**: Output values for accessing created resources
- **providers.tf**: AWS provider configuration

### Modules

- **bedrock_knowledge_base**: Creates and configures the Bedrock knowledge base connected to Confluence
- **bedrock_agent**: Sets up the Bedrock agent for interacting with the knowledge base

## Prerequisites

1. AWS account with appropriate permissions
2. Terraform installed (version 1.0.0 or later)
3. Confluence instance with API access
4. Confluence API key/token

## Required Variables

- `tenant`: Your tenant or customer name for resource isolation
- `env`: Environment name (e.g., dev, staging, prod)
- `confluence_host_url`: Your Confluence instance URL
- `confluence_api_key`: Your Confluence API key/token
- `agent_instruction`: Instructions for the Bedrock agent

## Optional Variables

- `aws_region`: AWS region (default: us-east-1)
- `knowledge_base_name`: Name for the Bedrock knowledge base (default: default-knowledge-base)
- `knowledge_base_description`: Description for the knowledge base
- `agent_name`: Name for the Bedrock agent (default: default-bedrock-agent)
- `agent_description`: Description for the agent
- `foundation_model`: ARN of the foundation model (default: amazon.titan-embed-text-v2:0)
- `agent_type`: Type of Bedrock agent (default: KNOWLEDGE_BASE)
- `tags`: Additional resource tags

## Usage

1. Clone this repository
2. Configure your AWS credentials
3. Create a terraform.tfvars file with your variables:

```hcl
tenant             = "mycompany"
env                = "dev"
confluence_host_url = "https://mycompany.atlassian.net"
confluence_api_key  = "your-api-key"
agent_instruction   = "You are a helpful assistant that answers questions about our company documentation."
```

4. Initialize and apply the Terraform configuration:

```bash
terraform init
terraform plan
terraform apply
```

## Outputs

- `bedrock_knowledge_base_id`: ID of the created knowledge base

## Security Considerations

- Confluence API credentials are stored securely in AWS Secrets Manager
- IAM roles follow the principle of least privilege
- S3 bucket is created with force_destroy enabled for cleanup

## License

This project is licensed under the MIT License. See the LICENSE file for details.
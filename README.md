# Confluence Knowledge Base Bot

A comprehensive solution for creating an AI-powered chatbot that can answer questions about your Confluence documentation through Slack. The bot uses AWS Bedrock for natural language processing and understanding, providing intelligent responses based on your Confluence content.

## Architecture Overview

The system is built on AWS services and consists of three main components that work together:

1. **Confluence Agent (AWS Bedrock)**: 
   - Connects to your Confluence instance via API
   - Creates and maintains a knowledge base using AWS Bedrock
   - Processes and answers questions using AI
   - Uses AWS Secrets Manager for secure credential storage
   - Includes S3 bucket for knowledge base data storage
   - Leverages IAM roles for secure service access

2. **Slack Bot**:
   - Runs as a serverless Lambda function
   - Connected to Slack via Events API
   - Receives user questions through mentions
   - Communicates with Bedrock agent via API Gateway
   - Delivers answers back to Slack channels
   - Uses AWS Secrets Manager for Slack credentials

3. **Infrastructure as Code**:
   - Modular Terraform configurations for each component
   - Terragrunt setup for environment management
   - Secure credential handling through AWS Secrets Manager
   - Automated IAM role and policy management
   - API Gateway configuration for secure endpoints

Data Flow:
1. User mentions the bot in Slack
2. Slack sends event to API Gateway
3. Lambda function processes the message
4. Bedrock agent queries the knowledge base
5. Response flows back through the same path
6. User receives the answer in Slack

## Repository Structure

```
confluence_bot/
├── confluence-agent-terraform/    # Bedrock agent infrastructure
│   ├── main.tf                   # Main Terraform configuration
│   ├── variables.tf              # Input variables
│   ├── outputs.tf                # Output values
│   └── modules/                  # Bedrock-specific modules
│       ├── bedrock_agent/        # Agent configuration
│       └── bedrock_knowledge_base/ # Knowledge base setup
│
├── slack_bot/                    # Slack integration
│   ├── src/                      # Lambda function code
│   │   ├── app.py               # Main application
│   │   └── requirements.txt      # Python dependencies
│   └── infra/                    # Slack bot infrastructure
│       ├── main.tf              # Infrastructure definition
│       └── variables.tf         # Configuration variables
│
└── example/                      # Example configurations
    └── terragrunt/              # Terragrunt deployment example
        ├── agent/               # Agent configuration
        ├── slack_bot/           # Slack bot configuration
        └── _env/                # Environment-specific settings
```

## Prerequisites

1. AWS Account with appropriate permissions
2. Confluence instance with API access
3. Slack workspace with admin access
4. Terraform (>= 1.0.0)
5. Terragrunt (for deployment)
6. Python 3.11 or later

## Deployment

This project uses Terragrunt for deployment. We provide an example configuration in the `example/terragrunt` directory that you can use as a reference for setting up your own deployment configuration.

### Example Configuration Structure

The `example/terragrunt` directory shows a recommended setup:

```
example/terragrunt/
├── _env/                  # Environment-specific variables
│   └── env.hcl           # Common variables for all components
├── agent/                 # Confluence agent configuration
│   └── terragrunt.hcl    # Agent-specific settings
└── slack_bot/            # Slack bot configuration
    └── terragrunt.hcl    # Slack bot-specific settings
```

### Setting Up Your Own Deployment

1. Create a new repository or directory for your infrastructure code
2. Set up your Terragrunt configuration following our example structure:
   ```
   your-infrastructure/
   ├── _env/
   │   └── env.hcl              # Your environment variables
   ├── confluence-bot/
   │   ├── agent/
   │   │   └── terragrunt.hcl   # Reference our agent module
   │   └── slack-bot/
   │       └── terragrunt.hcl   # Reference our slack bot module
   └── terragrunt.hcl           # Your root Terragrunt config
   ```

3. Configure your `env.hcl` with your settings:
   ```hcl
   # Example env.hcl structure - customize with your values
   locals {
     tenant = "your-company"
     environment = "dev"  # or prod, staging, etc.
     aws_region = "your-region"
     
     # Confluence Configuration
     confluence_host_url = "https://your-confluence-instance"
     
     # Other configurations...
   }
   ```

4. Reference our modules in your Terragrunt configurations:
   ```hcl
   # Example agent/terragrunt.hcl
   terraform {
     source = "git::https://github.com/your-org/confluence_bot//confluence-agent-terraform"
   }

   include "root" {
     path = find_in_parent_folders()
   }

   # Your specific configurations...
   ```

### Deployment Steps

1. Configure AWS credentials:
   ```bash
   export AWS_ACCESS_KEY_ID="your-access-key"
   export AWS_SECRET_ACCESS_KEY="your-secret-key"
   export AWS_REGION="your-region"
   ```

2. Initialize and deploy from your infrastructure directory:
   ```bash
   cd your-infrastructure/confluence-bot
   terragrunt run-all init
   terragrunt run-all plan
   terragrunt run-all apply
   ```

### Post-Deployment Configuration

1. Create a new Slack app at [api.slack.com](https://api.slack.com/apps)
2. Configure the app with the deployed API Gateway URL (available in Terragrunt outputs)
3. Add the bot to your workspace
4. Store the Slack credentials securely using your preferred method

## Reference

For detailed configuration options and module documentation:

- [Confluence Agent Module](./confluence-agent-terraform/README.md)
- [Slack Bot Module](./slack_bot/README.md)
- [Example Terragrunt Configuration](./example/terragrunt/README.md)

## Usage

1. Invite the bot to a Slack channel
2. Ask questions by mentioning the bot:
```
@confluence-bot What is our vacation policy?
```

The bot will:
1. Process your question
2. Search the Confluence knowledge base
3. Provide a relevant answer based on your documentation

## Security Considerations

- All credentials are stored in AWS Secrets Manager
- IAM roles follow the principle of least privilege
- API endpoints are properly secured
- Slack signing verification is implemented
- Confluence API tokens are encrypted

## Environment Variables

### Required for Deployment
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`

### Component-Specific
See individual component READMEs for detailed configuration options.

## Troubleshooting

Common issues and solutions:

1. **Slack Bot Not Responding**
   - Check API Gateway logs
   - Verify Slack event subscription URL
   - Confirm Lambda function permissions

2. **Incorrect Answers**
   - Review Bedrock agent configuration
   - Check Confluence connectivity
   - Verify knowledge base synchronization

3. **Deployment Issues**
   - Ensure AWS credentials are correct
   - Check resource limits
   - Verify all required variables are set

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Support

For issues and feature requests, please create an issue in the repository. 
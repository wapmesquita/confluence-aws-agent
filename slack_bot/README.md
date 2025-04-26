# Confluence Bot - Slack Integration

This component provides a Slack bot interface for the Confluence knowledge base bot. It allows users to interact with the Confluence knowledge base directly through Slack by mentioning the bot in channels or direct messages.

## Architecture Overview

The Slack bot consists of the following components:

- **Lambda Function**: Python-based bot handler that processes Slack events
- **API Gateway**: Endpoint for receiving Slack events
- **AWS Secrets Manager**: Secure storage for Slack credentials
- **Integration**: Connects to the Bedrock agent API for processing queries

## Directory Structure

```
slack_bot/
├── src/                    # Source code for the Lambda function
│   ├── app.py             # Main application code
│   └── requirements.txt    # Python dependencies
├── infra/                 # Terraform infrastructure code
│   ├── main.tf           # Main infrastructure definition
│   ├── variables.tf      # Input variables
│   └── outputs.tf        # Output values
└── .gen/                  # Generated files (e.g., Lambda deployment package)
```

## Prerequisites

1. AWS account with appropriate permissions
2. Terraform installed (version 1.0.0 or later)
3. Python 3.11 or later
4. Slack workspace with admin access
5. Slack app created with the following permissions:
   - `app_mentions:read`
   - `chat:write`
   - `channels:history`

## Setup Instructions

### 1. Create Slack App

1. Go to [Slack API](https://api.slack.com/apps) and create a new app
2. Enable Event Subscriptions
3. Subscribe to bot events: `app_mention`
4. Install the app to your workspace
5. Save the Bot User OAuth Token and Signing Secret

### 2. Deploy Infrastructure

1. Navigate to the `infra` directory
2. Create a `terraform.tfvars` file:

```hcl
tenant               = "mycompany"
env                  = "dev"
aws_region          = "us-east-1"
slack_secret_name   = "mycompany/dev/slack/credentials"
slack_bot_token     = "xoxb-your-bot-token"
slack_signing_secret = "your-signing-secret"
agent_api_url       = "https://your-bedrock-agent-api-url"
```

3. Initialize and apply Terraform:

```bash
terraform init
terraform plan
terraform apply
```

4. Configure the Slack app's Event Subscription URL with the output `slack_events_url`

### 3. Local Development

1. Install dependencies:
```bash
cd src
pip install -r requirements.txt
```

2. Set environment variables:
```bash
export SLACK_SECRET_NAME="mycompany/dev/slack/credentials"
export AWS_REGION="us-east-1"
export AGENT_API_URL="https://your-bedrock-agent-api-url"
```

3. Run the application:
```bash
python app.py
```

## Usage

Mention the bot in any channel where it's invited:

```
@confluence-bot What is our vacation policy?
```

The bot will:
1. Process the mention
2. Send the query to the Bedrock agent
3. Reply with the relevant information from your Confluence knowledge base

## Security Considerations

- Slack credentials are stored securely in AWS Secrets Manager
- Lambda function has minimal IAM permissions
- API Gateway endpoint is secured with Slack signature verification
- All infrastructure follows AWS security best practices

## Environment Variables

- `SLACK_SECRET_NAME`: Name of the AWS Secrets Manager secret containing Slack credentials
- `AWS_REGION`: AWS region for the deployment
- `AGENT_API_URL`: URL of the Bedrock agent API endpoint

## Infrastructure Outputs

- `slack_events_url`: The URL to configure in Slack's Event Subscriptions

## License

This project is licensed under the MIT License. See the LICENSE file for details. 
variable "agent_api_url" {
  description = "URL for the Bedrock agent API."
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy the bot."
  type        = string
  default     = "us-east-1"
}

variable "tenant" {
  description = "The tenant or customer name for resource isolation."
  type        = string
}

variable "env" {
  description = "The environment (e.g., dev, staging, prod)."
  type        = string
}

variable "slack_secret_name" {
  description = "Name of the AWS Secrets Manager secret containing Slack bot credentials."
  type        = string
}

variable "slack_bot_token" {
  description = "Slack Bot User OAuth Token."
  type        = string
}

variable "slack_signing_secret" {
  description = "Slack Signing Secret."
  type        = string
}

variable "lambda_zip_path" {
  description = "Path to the Lambda deployment package zip file"
  type        = string
  default     = ""
}

variable "create_lambda_file" {
  description = "Whether to create the Lambda zip file from the src directory if lambda_zip_path is not provided."
  type        = bool
  default     = false
}

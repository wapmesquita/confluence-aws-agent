variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
}

variable "knowledge_base_name" {
  description = "The name of the Bedrock knowledge base."
  type        = string
  default     = "default-knowledge-base"
}

variable "knowledge_base_description" {
  description = "Description for the Bedrock knowledge base."
  type        = string
  default     = "This is a default knowledge base."
}

variable "agent_name" {
  description = "The name of the Bedrock agent."
  type        = string
  default     = "default-bedrock-agent"
}

variable "agent_description" {
  description = "Description for the Bedrock agent."
  type        = string
  default     = "This is a default Bedrock agent."
}

variable "foundation_model" {
  description = "The foundation model ID for the Bedrock agent."
  type        = string
  default     = "arn:aws:bedrock:us-west-2::foundation-model/amazon.titan-embed-text-v2:0"
}

variable "agent_instruction" {
  description = "Instructions for the Bedrock agent."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "agent_type" {
  description = "The type of the Bedrock agent."
  type        = string
  default     = "KNOWLEDGE_BASE"
}

variable "confluence_host_url" {
  description = "The Confluence host URL or instance URL."
  type        = string
}

variable "confluence_api_key" {
  description = "The API key or token for Confluence."
  type        = string
}

variable "tenant" {
  description = "The tenant or customer name for resource isolation."
  type        = string
}

variable "env" {
  description = "The environment (e.g., dev, staging, prod)."
  type        = string
}
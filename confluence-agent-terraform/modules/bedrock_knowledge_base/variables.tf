variable "knowledge_base_name" {
  description = "The name of the knowledge base."
  type        = string
}

variable "knowledge_base_description" {
  description = "A description of the knowledge base."
  type        = string
  default     = "This is a knowledge base for AWS Bedrock."
}

variable "knowledge_base_tags" {
  description = "A map of tags to assign to the knowledge base."
  type        = map(string)
  default     = {}
}

variable "knowledge_base_type" {
  description = "The type of knowledge base."
  type        = string
  default     = "general"
}

variable "role_arn" {
  description = "The ARN of the IAM role for the knowledge base."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the knowledge base."
  type        = map(string)
  default     = {}
}

variable "confluence_host_url" {
  description = "The Confluence host URL or instance URL."
  type        = string
}

variable "confluence_secret_arn" {
  description = "The ARN of the AWS Secrets Manager secret for Confluence credentials."
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
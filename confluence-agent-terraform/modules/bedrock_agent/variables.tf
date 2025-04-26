variable "agent_name" {
  description = "The name of the Bedrock agent."
  type        = string
}

variable "agent_type" {
  description = "The type of the Bedrock agent."
  type        = string
}

variable "agent_role_arn" {
  description = "The ARN of the IAM role to be assumed by the Bedrock agent."
  type        = string
}

variable "agent_description" {
  description = "A description of the Bedrock agent."
  type        = string
  default     = ""
}

variable "agent_configuration" {
  description = "Configuration settings for the Bedrock agent."
  type        = map(string)
  default     = {}
}

variable "agent_resource_role_arn" {
  description = "The ARN of the IAM role for the Bedrock agent."
  type        = string
}

variable "foundation_model" {
  description = "The foundation model ID for the Bedrock agent."
  type        = string
}

variable "agent_instruction" {
  description = "Instructions for the Bedrock agent."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the Bedrock agent."
  type        = map(string)
  default     = {}
}

variable "tenant" {
  description = "The tenant or customer name for resource isolation."
  type        = string
}

variable "env" {
  description = "The environment (e.g., dev, staging, prod)."
  type        = string
}
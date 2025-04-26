locals {
  standard_tags = merge(var.tags, {
    tenant = var.tenant
    env    = var.env
  })
}

resource "aws_bedrockagent_agent" "agent" {
  agent_name              = "${var.tenant}-${var.env}-${var.agent_name}"
  agent_resource_role_arn = var.agent_resource_role_arn
  foundation_model        = var.foundation_model
  instruction             = var.agent_instruction
  description             = var.agent_description
  tags                    = local.standard_tags
}
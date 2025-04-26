resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  standard_tags = merge(var.tags, {
    tenant = var.tenant
    env    = var.env
  })
}

resource "aws_s3_bucket" "confluence_kb" {
  bucket        = "${var.tenant}-${var.env}-confluence-kb-${random_id.suffix.hex}"
  force_destroy = true
  tags          = local.standard_tags
}

resource "aws_iam_role" "bedrock_agent_role" {
  name               = "${var.tenant}-${var.env}-bedrock-agent-role"
  assume_role_policy = data.aws_iam_policy_document.bedrock_agent_assume.json
}

data "aws_iam_policy_document" "bedrock_agent_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "bedrock_agent_s3" {
  role       = aws_iam_role.bedrock_agent_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role" "bedrock_kb_role" {
  name               = "${var.tenant}-${var.env}-bedrock-kb-role"
  assume_role_policy = data.aws_iam_policy_document.bedrock_kb_assume.json
}

data "aws_iam_policy_document" "bedrock_kb_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["bedrock.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "bedrock_kb_s3" {
  role       = aws_iam_role.bedrock_kb_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_secretsmanager_secret" "confluence" {
  name = "${var.tenant}/${var.env}/confluence/bedrock/credentials"
}

resource "aws_secretsmanager_secret_version" "confluence" {
  secret_id = aws_secretsmanager_secret.confluence.id
  secret_string = jsonencode({
    api_key = var.confluence_api_key
  })
}

module "bedrock_knowledge_base" {
  source = "./modules/bedrock_knowledge_base"

  knowledge_base_name        = "${var.tenant}-${var.env}-${var.knowledge_base_name}"
  knowledge_base_description = var.knowledge_base_description
  role_arn                   = aws_iam_role.bedrock_kb_role.arn
  tags                       = local.standard_tags
  confluence_host_url        = var.confluence_host_url
  confluence_secret_arn      = aws_secretsmanager_secret.confluence.arn
  tenant                     = var.tenant
  env                        = var.env
}

module "bedrock_agent" {
  source = "./modules/bedrock_agent"

  agent_name              = "${var.tenant}-${var.env}-${var.agent_name}"
  agent_type              = var.agent_type
  agent_role_arn          = aws_iam_role.bedrock_agent_role.arn
  agent_resource_role_arn = aws_iam_role.bedrock_agent_role.arn
  foundation_model        = var.foundation_model
  agent_instruction       = var.agent_instruction
  agent_description       = var.agent_description
  tags                    = local.standard_tags
  tenant                  = var.tenant
  env                     = var.env
}

output "knowledge_base_arn" {
  value = module.bedrock_knowledge_base.knowledge_base_arn
}

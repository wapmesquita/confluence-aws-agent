locals {
  standard_tags = merge(var.tags, {
    tenant = var.tenant
    env    = var.env
  })
}

resource "aws_bedrockagent_knowledge_base" "knowledge_base" {
  name        = "${var.tenant}-${var.env}-${var.knowledge_base_name}"
  description = var.knowledge_base_description
  role_arn    = var.role_arn
  knowledge_base_configuration {
    vector_knowledge_base_configuration {
      embedding_model_arn = "arn:aws:bedrock:us-west-2::foundation-model/amazon.titan-embed-text-v2:0"
    }
    type = "VECTOR"
  }
  storage_configuration {
    type = "OPENSEARCH_SERVERLESS"
    opensearch_serverless_configuration {
      collection_arn    = aws_opensearchserverless_collection.kb_collection.arn
      vector_index_name = "${var.tenant}-${var.env}-kb-idx"
      field_mapping {
        vector_field   = "${var.tenant}-${var.env}-kb-vec"
        text_field     = "AMAZON_BEDROCK_TEXT_CHUNK"
        metadata_field = "AMAZON_BEDROCK_METADATA"
      }
    }
  }
  tags = local.standard_tags
}

resource "aws_bedrockagent_data_source" "confluence_source" {
  knowledge_base_id = aws_bedrockagent_knowledge_base.knowledge_base.id
  name              = "${var.tenant}-${var.env}-confluence-docs"
  description       = "Data source for Confluence workspace documents"

  data_source_configuration {
    type = "CONFLUENCE"
    confluence_configuration {
      source_configuration {
        host_url               = var.confluence_host_url
        host_type              = "SAAS"
        auth_type              = "BASIC"
        credentials_secret_arn = var.confluence_secret_arn
      }
      # Optionally, add crawler_configuration, etc.
    }
  }
}

resource "aws_opensearchserverless_collection" "kb_collection" {
  name = "${var.tenant}-${var.env}-kb-coll"
  type = "VECTORSEARCH"
}

output "knowledge_base_id" {
  value = aws_bedrockagent_knowledge_base.knowledge_base.id
}
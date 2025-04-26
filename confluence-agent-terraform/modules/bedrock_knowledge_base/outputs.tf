output "knowledge_base_name" {
  value = aws_bedrockagent_knowledge_base.knowledge_base.name
}

output "knowledge_base_arn" {
  value = aws_bedrockagent_knowledge_base.knowledge_base.arn
}

# output "knowledge_base_endpoint" {
#   value = aws_bedrockagent_knowledge_base.knowledge_base.endpoint
# }
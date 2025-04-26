locals {
  tenant = get_env("TENANT", "mytenant")
  env    = get_env("ENV", "dev")
  env_config = read_terragrunt_config(find_in_parent_folders("${local.tenant}/${local.env}.hcl"))
}

terraform {
  source = "git::https://github.com/wapmesquita/confluence-aws-agent.git//confluence-agent-terraform"
}

inputs = {
  tenant      = local.tenant
  env         = local.env
  aws_region  = local.env_config.locals.region
  agent_instruction = "You are a helpful assistant for the company. Use the knowledge base to answer questions accurately and always cite your sources. If you do not know the answer, say so."
  confluence_host_url = "https://mock.atlassian.net/wiki"
  confluence_api_key  = "mock-confluence-api-key"
}

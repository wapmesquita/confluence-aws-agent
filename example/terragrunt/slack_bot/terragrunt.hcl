locals {
  tenant = get_env("TENANT", "mytenant")
  env    = get_env("ENV", "dev")
  env_config = read_terragrunt_config(find_in_parent_folders("${local.tenant}/${local.env}.hcl"))
}

terraform {
  source = "git::https://github.com/wapmesquita/confluence-aws-agent.git//slack_bot/infra"
}

dependency "agent" {
  config_path = "../agent"
  mock_outputs = {
    knowledge_base_arn = "mock-arn"
  }
}

inputs = {
  tenant               = local.tenant
  env                  = local.env
  aws_region           = local.env_config.locals.region
  slack_secret_name    = "mock-slack-secret"
  slack_bot_token      = "xoxb-mock-bot-token"
  slack_signing_secret = "mock-signing-secret"
  agent_api_url        = dependency.agent.outputs.knowledge_base_arn
  lambda_zip_path      = "https://github.com/wapmesquita/confluence-aws-agent/releases/download/v1.0.0/src.zip"
}

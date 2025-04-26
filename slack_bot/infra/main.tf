locals {
  standard_tags = {
    tenant = var.tenant
    env    = var.env
  }
  function_name         = "${var.tenant}-${var.env}-slack-bot-handler"
  lambda_zip_path_final = var.lambda_zip_path == "" && var.create_lambda_file ? data.archive_file.slack_bot[0].output_path : ""
}

data "archive_file" "slack_bot" {
  count       = var.lambda_zip_path == "" && var.create_lambda_file ? 1 : 0
  type        = "zip"
  source_dir  = "../src"
  output_path = "../.gen/app.zip"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_lambda_function" "slack_bot" {
  function_name = local.function_name
  handler       = "app.lambda_handler"
  runtime       = "python3.11"
  filename = var.lambda_zip_path != "" ? var.lambda_zip_path : (
    var.create_lambda_file ? data.archive_file.slack_bot[0].output_path : ""
  )
  source_code_hash = var.lambda_zip_path != "" ? filebase64sha256(var.lambda_zip_path) : (
    var.create_lambda_file ? filebase64sha256(data.archive_file.slack_bot[0].output_path) : ""
  )
  role = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      SLACK_SECRET_NAME = var.slack_secret_name
      AWS_REGION        = var.aws_region
      AGENT_API_URL     = var.agent_api_url
    }
  }

  tags = local.standard_tags
}

# IAM role for Lambda (skeleton)
resource "aws_iam_role" "lambda_exec" {
  name = "${local.function_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
  tags = local.standard_tags
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_secrets" {
  name = "${local.function_name}-secrets-policy"
  role = aws_iam_role.lambda_exec.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = "*"
      }
    ]
  })
}

# TODO: Add API Gateway for Slack events, permissions, and outputs

resource "aws_api_gateway_rest_api" "slack_api" {
  name        = "${var.tenant}-${var.env}-slack-bot-api"
  description = "API Gateway for Slack bot events"
  tags        = local.standard_tags
}

resource "aws_api_gateway_resource" "slack_events" {
  rest_api_id = aws_api_gateway_rest_api.slack_api.id
  parent_id   = aws_api_gateway_rest_api.slack_api.root_resource_id
  path_part   = "slack"
}

resource "aws_api_gateway_resource" "events" {
  rest_api_id = aws_api_gateway_rest_api.slack_api.id
  parent_id   = aws_api_gateway_resource.slack_events.id
  path_part   = "events"
}

resource "aws_api_gateway_method" "post_events" {
  rest_api_id   = aws_api_gateway_rest_api.slack_api.id
  resource_id   = aws_api_gateway_resource.events.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.slack_api.id
  resource_id             = aws_api_gateway_resource.events.id
  http_method             = aws_api_gateway_method.post_events.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.slack_bot.invoke_arn
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.slack_bot.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.slack_api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "slack" {
  depends_on  = [aws_api_gateway_integration.lambda]
  rest_api_id = aws_api_gateway_rest_api.slack_api.id
}

resource "aws_api_gateway_stage" "slack" {
  stage_name    = var.env
  rest_api_id   = aws_api_gateway_rest_api.slack_api.id
  deployment_id = aws_api_gateway_deployment.slack.id
}

output "slack_events_url" {
  value       = "https://${aws_api_gateway_rest_api.slack_api.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.slack.stage_name}/slack/events"
  description = "URL for Slack to send events to."
}

resource "aws_secretsmanager_secret" "slack" {
  name = var.slack_secret_name
  tags = local.standard_tags
}

resource "aws_secretsmanager_secret_version" "slack" {
  secret_id = aws_secretsmanager_secret.slack.id
  secret_string = jsonencode({
    slack_bot_token      = var.slack_bot_token
    slack_signing_secret = var.slack_signing_secret
  })
}

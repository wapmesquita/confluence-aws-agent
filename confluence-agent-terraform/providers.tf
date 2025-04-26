provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "bedrock"
  region = var.aws_region
}
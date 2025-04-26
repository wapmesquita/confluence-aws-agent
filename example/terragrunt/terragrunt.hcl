terraform {
  # No source needed at the root, but copy_files_into_module is supported here
  copy_files_into_module = [
    {
      from = "${get_parent_terragrunt_dir()}/../../slack_bot/src"
      to   = "src"
    }
  ]
}

# Optionally, skip running any Terraform at the root
skip = true 
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "aws" {}

# current user
data "aws_caller_identity" "current" {}

# create an iam policy document
data "aws_iam_policy_document" "my_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = [
        data.aws_caller_identity.current.arn
      ]
    }
  }
}

# iam account password policy
resource "aws_iam_account_password_policy" "default" {
  minimum_password_length        = 32
  require_symbols                = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 10
}

# iam group
resource "aws_iam_group" "my_group" {
  name = "my_group"
}

# attach an iam policy to the group
resource "aws_iam_group_policy_attachment" "my_group_policy_attachment" {
  group      = aws_iam_group.my_group.name
  policy_arn = "arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"
}

# iam user
resource "aws_iam_user" "my_user" {
  name = "my_user"
}

# create random password
data "aws_secretsmanager_random_password" "my_user_password" {
  password_length            = 32
  require_each_included_type = true
}

# iam user login profile
resource "null_resource" "create_user_login_profile" {
  triggers = {
    user_name = aws_iam_user.my_user.name
    password  = data.aws_secretsmanager_random_password.my_user_password.random_password
  }

  provisioner "local-exec" {
    command = format("aws iam create-login-profile --user-name %s --password '%s'",
      aws_iam_user.my_user.name,
      data.aws_secretsmanager_random_password.my_user_password.random_password
    )
  }

  depends_on = [
    aws_iam_user.my_user,
    data.aws_secretsmanager_random_password.my_user_password
  ]
}

# attach user to group
resource "aws_iam_user_group_membership" "my_user_group_membership" {
  user = aws_iam_user.my_user.name
  groups = [
    aws_iam_group.my_group.name
  ]
}

output "password" {
  value = data.aws_secretsmanager_random_password.my_user_password.random_password
}

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

# create an iam role
resource "aws_iam_role" "my_role" {
  name               = "my_role"
  assume_role_policy = data.aws_iam_policy_document.my_role_policy.json
}

# output the role arn
output "role_arn" {
  value = aws_iam_role.my_role.arn
}

# attach an role policy 'PowerUserAccess'
resource "aws_iam_role_policy_attachment" "my_role_policy_attachment" {
  role       = aws_iam_role.my_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

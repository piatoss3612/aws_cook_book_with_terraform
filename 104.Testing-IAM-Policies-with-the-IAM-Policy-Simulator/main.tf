terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "aws" {}

/*
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
*/

// create an iam policy document
data "aws_iam_policy_document" "aws_cookbook_104_iam_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

// create an iam role
resource "aws_iam_role" "aws_cookbook_104_iam_role" {
  name               = "aws_cookbook_104_iam_role"
  assume_role_policy = data.aws_iam_policy_document.aws_cookbook_104_iam_policy_document.json
}

// attach AmazonEC2ReadOnlyAccess policy to the role
resource "aws_iam_role_policy_attachment" "aws_cookbook_104_iam_role_policy_attachment" {
  role       = aws_iam_role.aws_cookbook_104_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

// simulate the role
data "aws_iam_principal_policy_simulation" "aws_cookbook_104_iam_principal_policy_simulation" {
  policy_source_arn = aws_iam_role.aws_cookbook_104_iam_role.arn
  action_names      = ["ec2:CreateInternetGateway", "ec2:DescribeInstances"]
}

// output the simulation results
output "aws_cookbook_104_iam_principal_policy_simulation_results" {
  value = data.aws_iam_principal_policy_simulation.aws_cookbook_104_iam_principal_policy_simulation.results
}

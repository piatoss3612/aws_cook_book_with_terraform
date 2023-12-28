terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "aws" {}

# get current account id
data "aws_caller_identity" "current" {}

# create an s3 bucket
resource "aws_s3_bucket" "my-cloudtrail-bucket" {
  bucket        = "my-cloudtrail-bucket-20231228"
  force_destroy = true
}

# create an cloudtrail
resource "aws_cloudtrail" "my-cloudtrail" {
  depends_on            = [aws_s3_bucket.my-cloudtrail-bucket]
  name                  = "my-cloudtrail"
  s3_bucket_name        = aws_s3_bucket.my-cloudtrail-bucket.id
  is_multi_region_trail = true
}

# create iam policy for cloudtrail to write logs to s3 bucket
data "aws_iam_policy_document" "cloudtrail_to_s3_policy" {
  statement {
    sid    = "S3CloudTrailAcl"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
    }
    actions = ["s3:GetBucketAcl"]
    resources = [
      aws_s3_bucket.my-cloudtrail-bucket.arn
    ]
  }

  statement {
    sid    = "S3CloudTrailWrite"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com"
      ]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.my-cloudtrail-bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

# attach policy to bucket
resource "aws_s3_bucket_policy" "my-cloudtrail-bucket-policy" {
  bucket = aws_s3_bucket.my-cloudtrail-bucket.id
  policy = data.aws_iam_policy_document.cloudtrail_to_s3_policy.json
}

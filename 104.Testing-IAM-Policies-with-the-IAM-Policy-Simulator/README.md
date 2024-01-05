# 04.Testing IAM Policies with the IAM Policy Simulator

## Init

```bash
$ terraform init
```

## Apply

```bash
$ terraform apply --auto-approve
```

## Validate

```bash
$ terraform output
aws_cookbook_104_iam_principal_policy_simulation_results = toset([
  {
    "action_name" = "ec2:CreateInternetGateway"
    "allowed" = false # should be false because the policy only allows read-only access
    "decision" = "implicitDeny"
    "decision_details" = tomap({})
    "matched_statements" = toset([])
    "missing_context_keys" = toset([])
    "resource_arn" = "*"
  },
  {
    "action_name" = "ec2:DescribeInstances"
    "allowed" = true # should be true
    "decision" = "allowed"
    "decision_details" = tomap({})
    "matched_statements" = toset([
      {
        "source_policy_id" = "AmazonEC2ReadOnlyAccess"
        "source_policy_type" = "IAM Policy"
      },
    ])
    "missing_context_keys" = toset([])
    "resource_arn" = "*"
  },
])
```

## Destroy

```bash
$ terraform destroy --auto-approve
```
# 01. Creating and Assuming an IAM Role

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
$ aws sts assume-role --role-arn <role-arn> --role-session-name <role-session-name>
```

- `role-arn` - the ARN of the role from the terraform output
- `role-session-name` - a name for the session

## Destroy

```bash
$ terraform destroy --auto-approve
```
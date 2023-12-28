# 03.Enabling CloudTrail Logging

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
$ aws cloudtrail describe-trails --trail-name-list <trail-name>
$ aws cloudtrail get-trail-status --name <trail-name>
```

- `trail-name` - The name of the trail to be described.

## Destroy

```bash
$ terraform destroy --auto-approve
```
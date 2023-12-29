# 03.Enforcing IAM User Password Policies

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
$ aws iam get-account-password-policy
{
    "PasswordPolicy": {
        "MinimumPasswordLength": 32,
        "RequireSymbols": true,
        "RequireNumbers": true,
        "RequireUppercaseCharacters": true,
        "RequireLowercaseCharacters": true,
        "AllowUsersToChangePassword": true,
        "ExpirePasswords": true,
        "MaxPasswordAge": 90,
        "PasswordReusePrevention": 10
    }
}
```

## Destroy

```bash
$ terraform destroy --auto-approve
```
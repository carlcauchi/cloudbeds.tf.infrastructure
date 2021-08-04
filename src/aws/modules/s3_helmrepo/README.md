# Module: s3_helmrepo

Create an S3 bucket intended to serve as a Helm repo. Configures basic encryption and supports sharing the bucket across many accounts.

## Usage
```
module {
    source = "modules/s3_helmrepo"
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.52.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.52.0 |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs
enable_external_account_access

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_external_account_access"></a> [enable\_external\_account\_access](#input\enable\_external\_account\_access) | Enable functionality to allow external AWS accounts to be defined using allowed_accounts_ids/allowed_account_ids_write variables below. | `bool` | `false` | no |
| <a name="input_allowed_account_ids"></a> [allowed\_account\_ids](#input\_allowed\_account\_ids) | List of AWS account IDs to grant read-only access to the repo. Due to how policies are constructed, there's effectively a limit of about 9 accounts. Variable enable_external_account_access must be set to true. | `list(string)` | `[]` | no |
| <a name="input_allowed_account_ids_write"></a> [allowed\_account\_ids\_write](#input\_allowed\_account\_ids\_write) | List of AWS account IDs to grant write access to the repo. Due to how policies are constructed, there's effectively a limit of about 9 accounts. Variable enable_external_account_access must be set to true. | `list(string)` | `[]` | no |
| <a name="input_logging_bucket"></a> [logging\_bucket](#input\_logging\_bucket) | S3 bucket name to log bucket access requests to (optional) | `string` | `null` | no |
| <a name="input_logging_bucket_prefix"></a> [logging\_bucket\_prefix](#input\_logging\_bucket\_prefix) | S3 bucket prefix to log bucket access requests to (optional). If blank but a `logging_bucket` is specified, this will be set to the name of the bucket | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Bucket name for the helm repo. Specify to control the exact name of the bucket, otherwise use `name_suffix` | `string` | `null` | no |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | Bucket suffix for the repo (bucket will be named `[ACCOUNT_ID]-[REGION]-[name_suffix]`, not used if `name` is specified) | `string` | `"helmrepo"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to supported resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket"></a> [s3\_bucket](#output\_s3\_bucket) | Bucket name of the repo |
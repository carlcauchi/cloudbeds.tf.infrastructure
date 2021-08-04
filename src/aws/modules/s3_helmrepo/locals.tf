locals {
  bucket_name = var.name != null ? var.name : "${data.aws_caller_identity.current.account_id}-${data.aws_region.region.name}-${var.name_suffix}"

  logging_map = var.logging_bucket == null ? [] : [{
    bucket = var.logging_bucket
    prefix = var.logging_bucket_prefix != null ? var.logging_bucket_prefix : local.bucket_name
  }]
}

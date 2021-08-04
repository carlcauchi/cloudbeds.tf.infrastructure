# This bucket uses a dynamic block to generate logging.
resource "aws_s3_bucket" "bucket" {
  bucket = local.bucket_name
  acl    = "private"
  tags   = var.tags

  dynamic "logging" {
    for_each = local.logging_map

    content {
      target_bucket = logging.value.bucket
      target_prefix = logging.value.prefix
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "bucket-public-access-block" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_s3_bucket.bucket,
    aws_s3_bucket_policy.bucket-policy
  ]
}

resource "aws_s3_bucket_policy" "bucket-policy" {

  count = var.enable_external_account_access == true ? 1 : 0

  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.iam-policy-document.json
}
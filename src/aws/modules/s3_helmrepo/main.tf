##################################################

data "aws_caller_identity" "current" {
}

data "aws_region" "region" {
}

data "aws_iam_policy_document" "iam-policy-document" {
  dynamic "statement" {
    for_each = var.allowed_account_ids

    content {

      sid       = "Allow cross-account access to list objects (${statement.value})"
      actions   = ["s3:ListBucket"]
      effect    = "Allow"
      resources = [aws_s3_bucket.bucket.arn]

      principals {
        identifiers = ["arn:aws:iam::${statement.value}:root"]
        type        = "AWS"
      }
    }
  }

  dynamic "statement" {
    # Remove accounts with write access from this statement to keep policy size down
    for_each = setsubtract(var.allowed_account_ids, var.allowed_account_ids_write)

    content {
      sid       = "Allow Cross-account read-only access (${statement.value})"
      actions   = ["s3:GetObject*"]
      effect    = "Allow"
      resources = ["${aws_s3_bucket.bucket.arn}/*"]

      principals {
        identifiers = ["arn:aws:iam::${statement.value}:root"]
        type        = "AWS"
      }
    }
  }

  dynamic "statement" {
    for_each = var.allowed_account_ids_write

    content {
      sid = "Allow Cross-account write access (${statement.value})"
      actions = [
        "s3:GetObject*",
        "s3:PutObject*"
      ]
      effect    = "Allow"
      resources = ["${aws_s3_bucket.bucket.arn}/*"]

      principals {
        identifiers = ["arn:aws:iam::${statement.value}:root"]
        type        = "AWS"
      }
    }
  }
}

##################################################

locals {
  bucket_name = var.name != null ? var.name : "${data.aws_caller_identity.current.account_id}-${data.aws_region.region.name}-${var.name_suffix}"

  logging_map = var.logging_bucket == null ? [] : [{
    bucket = var.logging_bucket
    prefix = var.logging_bucket_prefix != null ? var.logging_bucket_prefix : local.bucket_name
  }]
}

##################################################

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

##################################################
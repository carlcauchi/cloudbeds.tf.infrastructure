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
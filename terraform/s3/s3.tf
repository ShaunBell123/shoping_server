provider "aws" {
  region = "eu-west-2"
}

resource "aws_s3_bucket" "tf_state_bucket" {
  bucket = "terraform-demo-state-shaun-2025"
}

resource "aws_s3_bucket_versioning" "tf_state_bucket_versioning" {
  bucket = aws_s3_bucket.tf_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "tf_state_bucket_block" {
  bucket                  = aws_s3_bucket.tf_state_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
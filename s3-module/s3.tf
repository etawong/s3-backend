#s3 bucket for terraform backend
resource "aws_s3_bucket" "backend" {
  bucket = "bootcamp32-${lower(var.env)}-${random_integer.backend.result}"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

# kms key for bucket encription
resource "aws_kms_key" "my_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.backend.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.my_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}


# random integer for bucket naming convention
resource "random_integer" "backend" {
  min = 1
  max = 100
  keepers = {
    # Generate a new integer each time we switch to a different environment
    Environment = var.env
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = title(var.versioning)
  }
}

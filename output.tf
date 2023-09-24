output "s3-Name" {
  value = aws_s3_bucket.backend.bucket
  #.bucket is the key "bucket" which returns the value
  # the value is the bucket name in s3.tf 
}
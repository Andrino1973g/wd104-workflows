# Data source for s3 bucket
data "aws_s3_bucket" "action_bucket" {
  provider = aws.west
  bucket = "wd104-state-bucket-104"
}
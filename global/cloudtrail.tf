resource "aws_s3_bucket" "trepp-genesis-cloudtrail" {
  bucket        = "trepp-genesis-cloudtrail"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::trepp-genesis-cloudtrail"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::trepp-genesis-cloudtrail/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "genesis-cloudtrail" {
  name                          = "trepp-genesis-cloudtrail"
  s3_bucket_name                = "${aws_s3_bucket.trepp-genesis-cloudtrail.id}"
  s3_key_prefix                 = "prefix"
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  include_global_service_events = true
}


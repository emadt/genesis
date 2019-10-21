provider "aws" {
  region = "${var.region}"
  profile = "${var.profile}"
}

resource "aws_sqs_queue" "trustee_notification_queue" {
  depends_on = ["aws_s3_bucket.trustee_bucket"]
  name = "trustee-notification-queue"
#  kms_master_key_id = "alias/aws/sqs" 
  tags = {
     Environment = "production_clo_trustee"
    }
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:trustee-notification-queue",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "${aws_s3_bucket.trustee_bucket.arn}" }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "trustee_bucket" {
  bucket = "trepp-production-clo-trustee"
  acl = "private"
   tags = {
     Environment = "production_clo_trustee"
    }
   versioning {
     enabled = true
     }
   server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_notification" "trustee_bucket_notification" {
  depends_on = ["aws_sqs_queue.trustee_notification_queue"]
  bucket = "${aws_s3_bucket.trustee_bucket.id}"

  queue {
    id = "object_upload"
    queue_arn     = "${aws_sqs_queue.trustee_notification_queue.arn}"
    events        = ["s3:ObjectCreated:*"]

  }
}

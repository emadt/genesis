output "trustee_notification_queue" {
  value = aws_sqs_queue.trustee_notification_queue.arn
}

output "trustee_bucket" {
  value = aws_s3_bucket.trustee_bucket.id
}

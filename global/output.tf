output "region"{
   value = var.region
}
output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}
output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}

output "security_group" {
  value = "${aws_security_group.allow_office.id}"
}

#data "aws_subnet_ids" "mysubnets" {
#  vpc_id = "${aws_vpc.main.id}"
#}

#data "aws_subnet" "mysubnets" {
#  count = "${length(data.aws_subnet_ids.mysubnets.ids)}"
#  id    = "${data.aws_subnet_ids.mysubnets.ids[count.index]}"
#}

#output "subnet_cidr_blocks" {
#  value = ["${data.aws_subnet.mysubnets.*.cidr_block}"]
#}
